# Agents Instructions for Odin Exercism

**Odin Version:** dev-2026-02-nightly

## MCP Servers Available

### Context7 (Documentation)

- `mcp-server-context7_resolve-library-id` - Resolve library names to Context7 IDs
- `mcp-server-context7_query-docs` - Query library documentation

### Exa Search (Web/Code Search)

- `mcp-server-exa-search_web_search_exa` - Web search
- `mcp-server-exa-search_get_code_context_exa` - Code examples search

### Threadbridge (Memory/Context)

- `mcp-server-threadbridge_save_thread` - Save conversation context
- `mcp-server-threadbridge_load_thread` - Load saved context
- `mcp-server-threadbridge_search_memory` - Search past conversations

### Arch Operations (System Management)

- `arch-ops-server_*` - Various Arch Linux package/system tools

## Guidelines for Odin Exercises

1. **DO NOT write directly to solution files** (e.g., `hello_world.odin`)
2. **Generate pseudocode** that is close to Odin language syntax
3. Use `.md` files or explain verbally instead of directly modifying solution files
4. Help user understand Odin concepts:
   - `proc` for procedures/functions
   - `->` for return types
   - `package` declaration
   - `import "core:..."` for core imports
   - `^` for pointers
   - `@(test)` for test procedures

## Running Tests

To test your Odin solution:

```bash
cd <exercise-folder>
odin test .
```
