class Rater
	constructor: (@engine, @kind) ->
		@db = new Bourne "./db-#{@kind}.json"
	add: (user, item, done) ->
		@db.find user: user, item: item, (err, res) =>
		if res.length > 0
			return done()

		@db.insert user: user, item: item, (err) =>
			async.series [
				(done) =>
					@engine.similars.update user, done
				(done) =>
					@engine.suggestions.update user, done
			], done
	remove: (user, item, done) ->
		@db.delete user: user, item: item, (err) =>
		async.series [
			(done) =>
				@engine.similars.update user, done
			(done) =>
				@engine.suggestions.update user, done
		], done
	itemsByUser: (user, done) ->
	usersByItem: (item, done) ->