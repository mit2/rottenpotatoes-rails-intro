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
    
    # Get all params from session and build db query
    def self.session_prev_state(usrsettings)
        if usrsettings["titlesort"] and usrsettings["hilite"]
            @movies = Movie.order(:title)
        elsif usrsettings["rdatesort"]
            Movie.order(:release_date)
        elsif usrsettings["ratings"]
            Movie.where({ rating: usrsettings["ratings"].keys})  
        end
            
    end
end


