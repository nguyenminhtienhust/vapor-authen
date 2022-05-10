import Fluent
import AsyncKit

struct CreatePhoneToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("user_phone_tokens")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("token", .string, .required)
            .field("expires_at", .datetime, .required)
            .unique(on: "user_id")
            .unique(on: "token")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("user_email_tokens").delete()
    }
}
