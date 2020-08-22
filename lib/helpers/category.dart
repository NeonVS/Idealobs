Map<int, String> match = {
  1: 'Production',
  2: 'Social',
  3: 'Educational',
  4: 'Community',
  5: 'Research',
  6: 'Business',
  7: 'IT',
  8: 'Science and Technology',
  9: 'Arts and Painting',
};

List<String> convertToCategory(Set<int> sets) {
  List<int> convertedSet = sets.toList();
  List<String> convertedList = convertedSet.map((e) => match[e]).toList();
  return convertedList;
}
