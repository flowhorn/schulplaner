
typedef String AverageInput(double value);

class AverageDisplay {
  AverageInput input;
  String name;
  AverageDisplay(this.input, {this.name = 'Standard'});

  String getAverageString(double value) {
    return input(value);
  }
}
