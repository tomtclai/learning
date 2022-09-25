

struct Pagination: Codable {
  let countPerPage: Int
  let totalCount: Int
  let currentPage: Int
  let totalPages: Int
}
