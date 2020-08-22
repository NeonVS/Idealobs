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

List<dynamic> itemDataProvider() {
  return [
    {
      'title': 'Research',
      'imageUrl':
          'https://image.freepik.com/free-vector/group-analysts-working-graphs_1262-21249.jpg'
    },
    {
      'title': 'Social',
      'imageUrl':
          'https://image.freepik.com/free-vector/startup-development_1284-22687.jpg'
    },
    {
      'title': 'Educational',
      'imageUrl':
          'https://image.freepik.com/free-vector/female-student-studying-with-laptop_74855-2396.jpg',
    },
    {
      'title': 'Community',
      'imageUrl':
          'https://image.freepik.com/free-vector/hipster-people-talking-using-computers-co-working_74855-5267.jpg'
    },
    {
      'title': 'Production',
      'imageUrl':
          'https://image.freepik.com/free-vector/people-working-factory-webpage_74855-2534.jpg'
    },
    {
      'title': 'Business',
      'imageUrl':
          'https://image.freepik.com/free-vector/two-business-partners-handshaking_74855-6685.jpg'
    },
    {
      'title': 'Information Technology',
      'imageUrl':
          'https://image.freepik.com/free-vector/tiny-people-using-mobile-application-with-map-outdoors_74855-7881.jpg'
    },
    {
      'title': 'Science and Technology',
      'imageUrl':
          'https://image.freepik.com/free-vector/interior-science-laboratory_178650-2866.jpg'
    },
    {
      'title': 'Arts and Painting',
      'imageUrl':
          'https://image.freepik.com/free-vector/prompt-poster-business-building-painting-ideas_82574-13399.jpg'
    }
  ];
}
