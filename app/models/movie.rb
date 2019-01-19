class Movie < ActiveRecord::Base
    
    # static method to hold Movie available ratings
    def self.ratings
       ['G','PG','PG-13','R'] 
    end
    
    def self.with_ratings(ratings)
    # ActiveRecord::Base api where
    # User.where({ name: ["Alice", "Bob"]})  " where name = alice and name = bob"
        Movie.where({ rating: ratings})
    end
end
