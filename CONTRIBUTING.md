# Contributing to Discord TK Tracker Bot

Thanks for your interest in contributing! Here's how you can help.

## Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📖 Improve documentation
- 🔧 Submit pull requests

## Reporting Bugs

When reporting bugs, please include:
- Ruby version (`ruby -v`)
- Operating system
- Steps to reproduce
- Expected vs actual behavior
- Any error messages

## Suggesting Features

Open an issue with:
- Clear description of the feature
- Use case / why it's useful
- Example of how it would work

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/discord-tk-tracker.git
   cd discord-tk-tracker
   ```
3. Install dependencies:
   ```bash
   gem install discordrb dotenv
   ```
4. Create a test bot on Discord (separate from production)
5. Set up `.env` with your test bot token
6. Create a test server and invite your bot

## Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes
   - Follow Ruby style conventions
   - Add comments for complex logic
   - Test your changes thoroughly

3. Commit your changes:
   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

4. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a Pull Request

## Code Style

- Use 2 spaces for indentation
- Keep lines under 100 characters when possible
- Add comments for non-obvious code
- Use descriptive variable names
- Follow existing patterns in the codebase

## Testing

Before submitting a PR:
- Test all commands work as expected
- Test admin permission checks
- Test error cases (invalid input, missing data, etc.)
- Make sure the bot starts without errors
- Verify data persists across restarts

## Pull Request Guidelines

- Describe what your PR does
- Reference any related issues
- Include screenshots/examples if relevant
- Make sure your code works with the latest main branch

## Feature Ideas

Some ideas for future features:
- Statistics export (CSV, graphs)
- Weekly/monthly automatic resets
- Per-channel tracking
- Role-based TK multipliers
- Integration with game APIs
- Web dashboard
- Undo last TK action
- TK history/audit log
- Custom command prefixes
- Multi-language support

Feel free to implement any of these or suggest your own!

## Questions?

Open an issue or discussion if you have questions about contributing.

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on the code, not the person
- Assume good intentions

Thanks for contributing! 🎉
