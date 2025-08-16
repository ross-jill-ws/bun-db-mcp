# 🚀 Bun Database MCP Server

A high-performance Model Context Protocol (MCP) server built with Bun and TypeScript, providing secure database operations for MySQL databases. This server enables AI assistants to safely interact with MySQL databases through a standardized protocol.

## 📹 Introduction Video

Watch this comprehensive tutorial to understand MCP Prompts & Resources by building the bun-db-mcp server:

[![Understand MCP Prompts & Resources by building bun-db-mcp](https://img.youtube.com/vi/SG07c8snBcw/0.jpg)](https://www.youtube.com/watch?v=SG07c8snBcw "Understand MCP Prompts & Resources by building bun-db-mcp")

## ✨ Features

- **🔌 Database Connection Management** - Connect, disconnect, and check connection status
- **🔍 Safe Query Execution** - Execute SELECT queries with parameterized statements
- **📝 CRUD Operations** - Create, Read, Update, and Delete records securely
- **📊 Schema Inspection** - Read database schema and table structures
- **🤖 MCP Prompts** - Pre-built prompts for common database operations
- **📚 MCP Resources** - Access database documentation and schema information
- **🛡️ SQL Injection Prevention** - Built-in validation and sanitization
- **⚡ Built with Bun** - Lightning-fast runtime and package management
- **🔒 Environment-based Configuration** - Secure credential management

## 📋 Prerequisites

- [Bun](https://bun.sh/) v1.0 or higher
- MySQL 5.7+ or MySQL 8.0+
- Node.js 18+ (for compatibility)

## 🛠️ Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bun-db-mcp.git
cd bun-db-mcp
```

2. Install dependencies:
```bash
bun install
```

3. Configure environment variables:
```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_user
DB_PASSWORD=your_password
DB_DATABASE=your_database
```

## 🚀 Usage

### Starting the Server

Run the MCP server:
```bash
bun run start
```

For development with auto-reload:
```bash
bun run dev
```

### Available Tools

The server provides six powerful tools for database operations:

#### 1. **connection** - Manage Database Connection
```json
{
  "action": "connect" | "disconnect" | "status"
}
```

#### 2. **query** - Execute SELECT Queries
```json
{
  "sql": "SELECT * FROM users WHERE age > ?",
  "params": [18]
}
```

#### 3. **create** - Insert Records
```json
{
  "table": "users",
  "data": {
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

#### 4. **update** - Update Records
```json
{
  "table": "users",
  "data": { "email": "newemail@example.com" },
  "where": { "id": 1 }
}
```

#### 5. **delete** - Delete Records
```json
{
  "table": "users",
  "where": { "id": 1 }
}
```

#### 6. **readSchema** - Inspect Database Schema
```json
{
  "table": "users"  // Optional - omit for all tables
}
```

### Available Prompts

The server provides pre-built prompts for common database operations:

#### 1. **query-employees** - Natural Language Queries
Query the employees table using natural language instructions.
- **Arguments**: `instructions` - e.g., "count female employees", "show 10 recent hires"

#### 2. **insert-employee** - Add New Employee
Insert a new employee with all related information (department, title, salary).
- **Arguments**: `employee_info` - Employee details in natural language

#### 3. **delete-employee** - Remove Employee
Delete an employee and all related records from the database.
- **Arguments**: `employee_identifier` - Employee number or name

#### 4. **manage-departments** - Department Operations
Insert a new department or delete an existing department.
- **Arguments**: `instructions` - e.g., "add Marketing department", "delete department d005"

### Available Resources

The server exposes the following MCP resources:

#### **bun-db-mcp://general-database** - Database Schema Documentation
- **Type**: `text/markdown`
- **Description**: Complete documentation of the employee database schema including:
  - Table structures and columns
  - Entity relationships
  - Key design patterns
  - Common query patterns
  - Mermaid ER diagram

## 🧪 Testing

Run the test suite:
```bash
bun test
```

Run specific test files:
```bash
bun test:db      # Database connection tests
bun test:tools   # Tool validation tests
```

Watch mode for development:
```bash
bun test:watch
```

## 🔧 Configuration

### MCP Client Configuration

To use with Claude Desktop or other MCP clients, add to your configuration:

```json
{
  "mcpServers": {
    "bun-db-mcp": {
      "command": "bun",
      "args": [
        "run",
        "<root path>/src/index.ts"
      ],
      "env": {
        "DB_HOST": "127.0.0.1",
        "DB_PORT": "3306",
        "DB_USER": "root",
        "DB_PASSWORD": "<your_password>",
        "DB_DATABASE": "employees"
      }
    }
  }
}
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | MySQL host address | `localhost` |
| `DB_PORT` | MySQL port | `3306` |
| `DB_USER` | Database user | `root` |
| `DB_PASSWORD` | Database password | - |
| `DB_DATABASE` | Database name | `mcp_test` |

## 🏗️ Project Structure

```
bun-db-mcp/
├── src/
│   ├── index.ts           # Main MCP server
│   ├── db/
│   │   ├── connection.ts  # Database connection manager
│   │   └── types.ts       # TypeScript type definitions
│   ├── tools/
│   │   └── index.ts       # Tool implementations
│   ├── specs/
│   │   ├── database-schema.md     # Database schema documentation
│   │   ├── query-employees.md     # Query prompt specification
│   │   ├── insert-employee-info.md # Insert prompt specification
│   │   ├── delete-employee.md     # Delete prompt specification
│   │   └── manage-departments.md  # Department management prompt
│   └── utils/
│       └── validation.ts  # Input validation & sanitization
├── tests/
│   ├── db.test.ts         # Database tests
│   └── tools.test.ts      # Tool tests
├── .env.example           # Environment template
└── package.json           # Project configuration
```

## 🔒 Security Features

- **Parameterized Queries** - All queries use prepared statements to prevent SQL injection
- **Input Validation** - Table and column names are validated against strict patterns
- **Identifier Escaping** - Database identifiers are properly escaped
- **SELECT-only Queries** - Query tool restricted to SELECT statements only
- **Environment Variables** - Sensitive credentials stored in environment files

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Bun](https://bun.sh/) - The fast all-in-one JavaScript runtime
- Uses [MCP SDK](https://github.com/modelcontextprotocol/sdk) for protocol implementation
- Database connectivity via [mysql2](https://github.com/sidorares/node-mysql2)

## 📊 Performance

Thanks to Bun's optimized runtime:
- 🚀 **Fast Startup** - Server starts in milliseconds
- ⚡ **Low Memory** - Efficient memory usage
- 🔥 **High Throughput** - Handle multiple database operations efficiently

## 🐛 Troubleshooting

### Common Issues

1. **Connection Refused**
   - Verify MySQL is running
   - Check host and port in `.env`
   - Ensure user has proper permissions

2. **Authentication Failed**
   - Verify credentials in `.env`
   - Check MySQL user permissions
   - Ensure database exists

3. **Module Not Found**
   - Run `bun install` to install dependencies
   - Verify Bun version with `bun --version`

## 📞 Support

For issues and questions:
- Open an issue on [GitHub Issues](https://github.com/yourusername/bun-db-mcp/issues)
- Check existing issues for solutions
- Provide detailed error messages and steps to reproduce

---

Built with ❤️ using Bun and TypeScript