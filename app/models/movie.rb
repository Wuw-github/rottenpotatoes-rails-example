class Movie < ActiveRecord::Base

    def Movie.all_ratings
        return ['G', 'PG', 'PG-13', 'R']
    end

    def self.with_ratings(rating_list)
        if rating_list == nil
            return Movie.all
        end
        ret = []
        rating_list.each do |rate, value|
            ret += Movie.where(rating: rate)
        end

        return ret
    end
end
