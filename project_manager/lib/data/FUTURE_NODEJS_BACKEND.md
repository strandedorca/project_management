# Future Node.js Backend - Architecture Guide

## ⚠️ IMPORTANT: This is for LATER

**Don't build this now!** Focus on your MVP with in-memory storage first. This guide shows you what you'll build AFTER your MVP is working.

**Why plan ahead?** Understanding the end goal helps you structure your Flutter code better (especially API models and service layers).

---

## What Your Node.js Backend Would Do

### Core Purpose
1. **Store data** - Projects and tasks in a database
2. **Provide API** - REST endpoints for your Flutter app to call
3. **Handle business logic** - Validation, authentication, etc.
4. **Sync across devices** - User can access data from phone/tablet/web

---

## Technology Stack Options

### Option A: Simple & Fast (Recommended for Learning)
- **Runtime:** Node.js
- **Framework:** Express.js (simplest, most popular)
- **Database:** PostgreSQL (or MongoDB if you prefer NoSQL)
- **ORM/Query Builder:** Prisma (easiest for beginners) or TypeORM
- **Authentication:** JWT (JSON Web Tokens)

### Option B: More Features
- Everything from Option A
- **Real-time:** Socket.io (for live updates)
- **File Storage:** AWS S3 or Cloudinary (if you add file uploads)

### Option C: Full-Stack Framework
- **NestJS** (more structured, like Angular for backend)
- **Next.js API routes** (if you also want a web app)

**Recommendation:** Start with Option A. Learn Express + PostgreSQL. Add features as needed.

---

## Project Structure

```
backend/
├── src/
│   ├── controllers/          # Handle HTTP requests
│   │   ├── project.controller.ts
│   │   └── task.controller.ts
│   ├── services/             # Business logic
│   │   ├── project.service.ts
│   │   └── task.service.ts
│   ├── models/               # Database models
│   │   ├── Project.ts
│   │   └── Task.ts
│   ├── routes/               # API routes
│   │   ├── project.routes.ts
│   │   └── task.routes.ts
│   ├── middleware/           # Auth, validation, etc.
│   │   ├── auth.middleware.ts
│   │   └── validate.middleware.ts
│   ├── utils/                # Helper functions
│   │   └── logger.ts
│   └── app.ts                # Express app setup
├── prisma/                   # Database schema (if using Prisma)
│   └── schema.prisma
├── package.json
└── .env                      # Environment variables
```

---

## Database Schema (PostgreSQL)

### Projects Table
```sql
CREATE TABLE projects (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  deadline TIMESTAMP NOT NULL,
  status VARCHAR(50) NOT NULL,  -- 'ongoing', 'notStarted', 'completed'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  user_id VARCHAR(255) NOT NULL  -- For multi-user support
);

CREATE INDEX idx_projects_user_id ON projects(user_id);
CREATE INDEX idx_projects_deadline ON projects(deadline);
```

### Tasks Table
```sql
CREATE TABLE tasks (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  project_id VARCHAR(255) NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  due_date TIMESTAMP,
  status VARCHAR(50) NOT NULL,  -- 'pending', 'inProgress', 'completed'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
```

**Key Points:**
- `project_id` is a foreign key (references projects table)
- `ON DELETE CASCADE` means deleting a project deletes its tasks
- Indexes speed up queries (especially filtering by user_id, project_id)

---

## API Endpoints (REST)

### Projects API

```
GET    /api/projects              # Get all projects for current user
GET    /api/projects/:id          # Get single project
POST   /api/projects              # Create project
PUT    /api/projects/:id          # Update project
DELETE /api/projects/:id          # Delete project

GET    /api/projects/ongoing      # Get ongoing projects
GET    /api/projects/upcoming     # Get upcoming deadlines
```

### Tasks API

```
GET    /api/tasks                 # Get all tasks for current user
GET    /api/tasks/project/:id     # Get tasks for a project
GET    /api/tasks/:id             # Get single task
POST   /api/tasks                 # Create task
PUT    /api/tasks/:id             # Update task
DELETE /api/tasks/:id             # Delete task

GET    /api/tasks/due             # Get due tasks (next 7 days)
```

**REST Convention:**
- `GET` = Read data
- `POST` = Create new data
- `PUT` = Update existing data
- `DELETE` = Remove data

---

## Example Code Structure

### 1. Express App Setup (`app.ts`)

```typescript
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import projectRoutes from './routes/project.routes';
import taskRoutes from './routes/task.routes';
import { authMiddleware } from './middleware/auth.middleware';

const app = express();

// Middleware
app.use(helmet()); // Security
app.use(cors()); // Allow Flutter app to connect
app.use(express.json()); // Parse JSON request bodies

// Routes
app.use('/api/projects', authMiddleware, projectRoutes);
app.use('/api/tasks', authMiddleware, taskRoutes);

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### 2. Project Controller (`controllers/project.controller.ts`)

```typescript
import { Request, Response } from 'express';
import { ProjectService } from '../services/project.service';

export class ProjectController {
  constructor(private projectService: ProjectService) {}

  // GET /api/projects
  async getAll(req: Request, res: Response) {
    try {
      const userId = req.user.id; // From auth middleware
      const projects = await this.projectService.getAll(userId);
      res.json(projects);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/projects/:id
  async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const project = await this.projectService.getById(id, userId);
      
      if (!project) {
        return res.status(404).json({ error: 'Project not found' });
      }
      
      res.json(project);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // POST /api/projects
  async create(req: Request, res: Response) {
    try {
      const userId = req.user.id;
      const projectData = req.body;
      
      // Validate input
      if (!projectData.name || !projectData.deadline) {
        return res.status(400).json({ error: 'Name and deadline are required' });
      }
      
      const project = await this.projectService.create(userId, projectData);
      res.status(201).json(project);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // PUT /api/projects/:id
  async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const updates = req.body;
      
      const project = await this.projectService.update(id, userId, updates);
      res.json(project);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // DELETE /api/projects/:id
  async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      
      await this.projectService.delete(id, userId);
      res.status(204).send(); // No content
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}
```

### 3. Project Service (`services/project.service.ts`)

```typescript
import { ProjectRepository } from '../repositories/project.repository';
import { Project } from '../models/Project';

export class ProjectService {
  constructor(private repository: ProjectRepository) {}

  async getAll(userId: string): Promise<Project[]> {
    return this.repository.findByUserId(userId);
  }

  async getById(id: string, userId: string): Promise<Project | null> {
    const project = await this.repository.findById(id);
    
    // Security: Make sure user owns this project
    if (!project || project.userId !== userId) {
      return null;
    }
    
    return project;
  }

  async create(userId: string, data: any): Promise<Project> {
    // Generate ID (or use UUID)
    const id = this.generateId();
    
    const project = new Project({
      id,
      name: data.name,
      description: data.description,
      deadline: new Date(data.deadline),
      status: data.status || 'notStarted',
      userId,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
    
    return this.repository.create(project);
  }

  async update(id: string, userId: string, updates: any): Promise<Project> {
    // Get existing project
    const existing = await this.getById(id, userId);
    if (!existing) {
      throw new Error('Project not found');
    }
    
    // Merge updates
    const updated = {
      ...existing,
      ...updates,
      updatedAt: new Date(),
    };
    
    return this.repository.update(updated);
  }

  async delete(id: string, userId: string): Promise<void> {
    const project = await this.getById(id, userId);
    if (!project) {
      throw new Error('Project not found');
    }
    
    await this.repository.delete(id);
  }

  private generateId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9);
  }
}
```

### 4. Project Routes (`routes/project.routes.ts`)

```typescript
import { Router } from 'express';
import { ProjectController } from '../controllers/project.controller';
import { ProjectService } from '../services/project.service';
import { ProjectRepository } from '../repositories/project.repository';

const router = Router();
const repository = new ProjectRepository();
const service = new ProjectService(repository);
const controller = new ProjectController(service);

router.get('/', controller.getAll.bind(controller));
router.get('/:id', controller.getById.bind(controller));
router.post('/', controller.create.bind(controller));
router.put('/:id', controller.update.bind(controller));
router.delete('/:id', controller.delete.bind(controller));

export default router;
```

### 5. Authentication Middleware (`middleware/auth.middleware.ts`)

```typescript
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  try {
    // Get token from header
    const token = req.headers.authorization?.split(' ')[1]; // "Bearer TOKEN"
    
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    
    // Add user info to request (so controllers can use it)
    req.user = decoded;
    
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
}
```

---

## How Flutter Connects

### Before (In-Memory):
```dart
final projectRepo = InMemoryProjectRepository();
final project = projectRepo.create(newProject);
```

### After (With Backend):
```dart
// Create API client
final apiClient = ApiClient(baseUrl: 'https://api.yourapp.com');

// Make HTTP request
final response = await apiClient.post('/api/projects', body: {
  'name': project.name,
  'deadline': project.deadline.toIso8601String(),
});

final createdProject = Project.fromJson(response.data);
```

**Key Change:** Your Flutter repository implementation would make HTTP calls instead of using Lists.

---

## Package.json Dependencies

```json
{
  "name": "project-manager-backend",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "cors": "^2.8.5",
    "helmet": "^6.0.0",
    "jsonwebtoken": "^9.0.0",
    "bcrypt": "^5.1.0",
    "dotenv": "^16.0.0",
    "pg": "^8.8.0",           // PostgreSQL driver
    "prisma": "^4.0.0"        // ORM (optional but recommended)
  },
  "devDependencies": {
    "@types/express": "^4.17.0",
    "@types/node": "^18.0.0",
    "typescript": "^4.9.0",
    "ts-node": "^10.9.0",
    "nodemon": "^2.0.0"
  }
}
```

---

## Environment Variables (.env)

```env
# Server
PORT=3000
NODE_ENV=development

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/project_manager

# JWT Secret (generate a random string)
JWT_SECRET=your-super-secret-key-here-change-this

# CORS (allow Flutter app to connect)
CORS_ORIGIN=http://localhost:3000
```

---

## Database with Prisma (Recommended)

### Schema (`prisma/schema.prisma`)

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Project {
  id          String   @id @default(uuid())
  name        String
  description String?
  deadline    DateTime
  status      String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  userId      String
  
  tasks       Task[]   // Relationship to tasks
  
  @@index([userId])
  @@index([deadline])
}

model Task {
  id          String   @id @default(uuid())
  name        String
  description String?
  projectId   String
  dueDate     DateTime?
  status      String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  project     Project  @relation(fields: [projectId], references: [id], onDelete: Cascade)
  
  @@index([projectId])
  @@index([dueDate])
}
```

**Benefits of Prisma:**
- Type-safe database queries
- Auto-generated TypeScript types
- Migrations (database version control)
- Easy relationships

---

## Authentication Flow

### 1. User Signs Up/Logs In
```
POST /api/auth/register
POST /api/auth/login
```

### 2. Server Returns JWT Token
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user-123",
    "email": "user@example.com"
  }
}
```

### 3. Flutter App Stores Token
```dart
// Save token
await storage.write(key: 'auth_token', value: token);
```

### 4. Flutter Includes Token in Requests
```dart
headers: {
  'Authorization': 'Bearer $token',
}
```

### 5. Backend Validates Token (via middleware)
- Extracts user ID from token
- Only returns user's own projects/tasks

---

## Deployment Options

### Option A: Heroku (Easiest)
- Free tier available
- Simple deployment
- Good for learning

### Option B: Railway / Render
- Modern alternatives to Heroku
- Free tiers
- Easy PostgreSQL setup

### Option C: AWS / Google Cloud / Azure
- More control
- More complex
- Better for production apps

**For MVP:** Start with Railway or Render. Super easy, free tier.

---

## Cost Breakdown

### Free Tier (Perfect for MVP)
- **Backend hosting:** Railway/Render (free)
- **Database:** PostgreSQL on Railway/Render (free)
- **Total:** $0/month

### If You Grow
- Backend: $5-10/month
- Database: $5-10/month
- **Total:** ~$15/month for small usage

---

## Migration Path (When You're Ready)

### Step 1: Keep In-Memory Working
- Don't break existing functionality
- Build backend alongside

### Step 2: Create API Client in Flutter
```dart
// lib/data/api/api_client.dart
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  
  Future<Response> get(String endpoint) { ... }
  Future<Response> post(String endpoint, {Map body}) { ... }
}
```

### Step 3: Create API Repository Implementations
```dart
// lib/data/repositories/api_project_repository.dart
class ApiProjectRepository implements ProjectRepository {
  final ApiClient _api;
  
  @override
  List<Project> getAll() {
    final response = await _api.get('/api/projects');
    return (response.data as List).map((json) => Project.fromJson(json)).toList();
  }
}
```

### Step 4: Swap Implementations
```dart
// In main.dart
// Change from:
final projectRepo = InMemoryProjectRepository();

// To:
final projectRepo = ApiProjectRepository(apiClient);
```

**Key:** Your UI code doesn't change! Same interface, different implementation.

---

## Learning Path

### Phase 1: MVP (Now)
- ✅ Flutter with in-memory storage
- ✅ Repository pattern
- ✅ Service layer

### Phase 2: Learn Backend Basics (After MVP)
- Node.js basics
- Express.js tutorial
- PostgreSQL basics
- REST API concepts

### Phase 3: Build Simple Backend
- Create Express app
- Set up PostgreSQL
- Build projects API
- Add authentication

### Phase 4: Connect Flutter
- Create API client
- Swap repository implementations
- Handle loading states
- Handle errors

### Phase 5: Deploy
- Deploy backend (Railway/Render)
- Update Flutter app to use production URL
- Test everything works

---

## Summary

**Your Node.js backend would:**
1. Use Express.js for HTTP server
2. Store data in PostgreSQL
3. Provide REST API endpoints
4. Use JWT for authentication
5. Be deployed on Railway/Render (free tier)

**Key Architecture:**
- Controllers → Services → Repositories → Database
- Same pattern as your Flutter app!
- Makes it easier to understand both sides

**When to Build:**
- AFTER your MVP works with in-memory storage
- When you need multi-device sync
- When you want to share data across devices

**Why Plan Ahead:**
- Helps structure Flutter code better
- Understanding end goal makes decisions easier
- You'll recognize patterns when you build it

---

**For Now:** Focus on MVP with in-memory storage. This backend structure will be here when you're ready! 🚀
