run tests:

just test: 
flutter test

test with coverage:  
flutter test --coverage && genhtml -o coverage coverage/lcov.info && xdg-open coverage/index.html

example tests:
https://github.com/brianegan/flutter_architecture_samples/tree/master/bloc_library/test

complete system:
https://medium.com/flutter-community/flutter-essential-what-you-need-to-know-567ad25dcd8f#47f1

dio test:
https://medium.com/@sahasuthpala/unit-testing-in-dio-dart-package-91b7a78314bc