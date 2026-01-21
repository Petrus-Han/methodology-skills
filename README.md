# Methodology Skills

A collection of reusable Claude Code skills for efficient project management, software design, and team collaboration.

## Skills

### first-principles-design

First-principles approach to plugin/software design. Use when:
- Designing new plugins or features
- Evaluating feature requests
- Simplifying existing implementations

**Core principle**: "What is the simplest thing that could possibly work?"

### first-principles-pm

First-principles project management - from idea to execution with maximum efficiency. Use when:
- Starting new projects
- Evaluating requirements
- Managing development workflow

**Core philosophy**: "The best part is no part. The best process is no process."

### collaborative-progress

Team progress management with structured markdown files. Use when:
- Managing multi-person projects
- Tracking task ownership and ETA
- Coordinating branch workflows

**Core files**: `PLAN.md`, `RISKS.md`, `PROGRESS.md`

**Git integration**: Update progress on main branch before creating feature branch and after merging.

## The 5-Step Algorithm

All skills follow the same fundamental algorithm:

1. **Question** - Challenge every requirement
2. **Delete** - Remove parts and processes ruthlessly
3. **Simplify** - Optimize what remains
4. **Accelerate** - Speed up the cycle
5. **Automate** - Only after steps 1-4

## Installation

### Global Installation (Recommended)

Use the install script to symlink skills to your global Claude Code directory:

```bash
# Install all skills globally
./install.sh install

# Check installation status
./install.sh list

# Uninstall
./install.sh uninstall
```

### Per-Project Installation

Copy the `.claude/skills/` directory to your project to enable these skills in Claude Code.

```bash
cp -r .claude/skills/ /path/to/your/project/.claude/skills/
```

## License

MIT
