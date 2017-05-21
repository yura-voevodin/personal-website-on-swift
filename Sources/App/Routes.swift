import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        // Pages
        builder.resource("/", PageController(view))
        
        // Blog
        builder.resource("posts", PostController(view))
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
    }
    
    // TODO: Refactor to middleware
    fileprivate func addRequest() {
        if let (day, month, year) = Date().calendarComponents {
            do {
                if let session = try Session.makeQuery()
                    .filter("year", year)
                    .filter("month", month)
                    .filter("day", day)
                    .first() {
                    session.requests += 1
                    try session.save()
                } else {
                    let newSession = Session(day: day, month: month, year: year, requests: 1)
                    try newSession.save()
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
}
