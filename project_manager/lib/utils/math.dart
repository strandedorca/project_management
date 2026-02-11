class Math {
  Math._();

  static double linearMap(
    double value,
    double upperX,
    double lowerX,
    double upperY,
    double lowerY,
  ) {
    // Linear equation: y = mx + b
    // -  a: scaling factor
    // -  b: offset
    // -  x: input value
    // -  y: output value
    // -  upperX: upper bound of input value
    // -  lowerX: lower bound of input value
    // -  upperY: upper bound of output value
    // -  lowerY: lower bound of output value
    // -> y = (x - lowerX) * (upperY - lowerY) / (upperX - lowerX) + lowerY

    // If the input range is 0, return the middle value of the output range
    final inputRange = upperX - lowerX;
    if (inputRange == 0) return (upperY + lowerY) / 2;

    return (value - lowerX) * (upperY - lowerY) / inputRange + lowerY;
  }
}
