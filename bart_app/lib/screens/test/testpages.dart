import 'package:flutter/material.dart';

class TestPage1 extends StatelessWidget {
  const TestPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 1',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

class TestPage2 extends StatelessWidget {
  const TestPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 2',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

class TestPage3 extends StatelessWidget {
  const TestPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 3',
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}

class TestPage4 extends StatelessWidget {
  const TestPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 4',
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}

class TestPage5 extends StatelessWidget {
  const TestPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 5',
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}

class TestPage6 extends StatelessWidget {
  const TestPage6({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Test Page 6',
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}
