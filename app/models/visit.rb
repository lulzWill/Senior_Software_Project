class Visit < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    
    def self.get_dates id
        visit = Visit.find(id)
        visit_dates = visit.start_date.to_s
        if visit.start_date != visit.end_date
            visit_dates += " to " + visit.end_date.to_s
        end
        return visit_dates
    end

end
