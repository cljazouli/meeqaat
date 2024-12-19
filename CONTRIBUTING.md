# Contributing to Meeqaat

Thank you for considering contributing to Meeqaat! Contributions of all kinds are welcome, including bug reports, feature suggestions, documentation improvements, and code contributions. Together, we can make this project more robust and useful for the community.

## Table of Contents

- [Getting Started](#getting-started)
- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
  - [Reporting Issues](#reporting-issues)
  - [Suggesting Features](#suggesting-features)
  - [Contributing Code](#contributing-code)
  - [Improving Documentation](#improving-documentation)
- [Development Guidelines](#development-guidelines)
  - [Branching Strategy](#branching-strategy)
  - [Commit Messages](#commit-messages)
  - [Code Style](#code-style)
- [Setting Up the Project Locally](#setting-up-the-project-locally)

---

## Getting Started

If this is your first time contributing to an open-source project, welcome! Here’s a quick guide to get you started:

1. Familiarize yourself with the project’s goals and structure by reading the [README file](./README.md).
2. Identify an area where you’d like to contribute—this could be fixing bugs, adding features, or improving documentation.
3. Follow the instructions in the sections below to submit your contribution.

---

## Code of Conduct

This project adheres to a [Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report any unacceptable behavior to the repository maintainer.

---

## How to Contribute

### Reporting Issues

If you find a bug or have a question, please open an issue in the GitHub repository. To make your report clear and actionable, include:

- A descriptive title.
- Steps to reproduce the issue.
- Expected and actual behavior.
- Screenshots or logs, if applicable.

### Suggesting Features

To suggest a feature, open an issue and use the following format:

1. **Describe the feature**: Provide a clear and concise description of what you want to happen.
2. **Motivation**: Explain why this feature would be useful.
3. **Additional context**: Include any mockups, links, or related discussions.

### Contributing Code

To contribute code:

1. Fork the repository.
2. Clone your fork to your local machine.
3. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/amazing-feature
   ```
4. Write your code and test thoroughly.
5. Commit your changes with a meaningful message.
6. Push your branch:
   ```bash
   git push origin feature/amazing-feature
   ```
7. Open a pull request from your branch to the `master` branch of the original repository.
8. Engage in the review process and address feedback.

### Improving Documentation

Good documentation is crucial. If you notice typos, outdated content, or unclear instructions, feel free to submit an issue or directly open a pull request to address it.

---

## Development Guidelines

### Branching Strategy

- **main**: Production-ready code.
- **feature/**: New features or enhancements.
- **bugfix/**: Bug fixes.
- **docs/**: Documentation improvements.

### Commit Messages

Write descriptive commit messages. Use the following format:

```
feat: Add prayer notification feature
fix: Correct timezone issue in prayer times
chore: Update dependencies
```

### Code Style

- Follow Dart’s best practices and the [Effective Dart guide](https://dart.dev/guides/language/effective-dart).
- Use `flutter analyze` to ensure code quality.
- Format your code with `flutter format` before committing.

---

## Setting Up the Project Locally

Follow these steps to set up the project on your local machine:

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/meeqaat.git
   ```
2. Navigate to the project directory:
   ```bash
   cd meeqaat
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```
5. To run tests:
   ```bash
   flutter test
   ```

---

Thank you for contributing to Meeqaat! We’re excited to have your input in improving the project.

