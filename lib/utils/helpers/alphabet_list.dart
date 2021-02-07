class AlphabetList {
  static List<String> getAlphabet() {
    return List.generate(
        26, (index) => String.fromCharCode("A".codeUnits.first + index));
  }
}
