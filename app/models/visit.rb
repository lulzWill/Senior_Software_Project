class Visit < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    belongs_to :leg
    
    def self.get_dates(id)
        visit = Visit.find(id)
        visit_dates = visit.start_date.to_s
        if visit.start_date != visit.end_date
            visit_dates += " to " + visit.end_date.to_s
        end
        return visit_dates
    end

    def self.overlap?(user_id, location_id, start_date, end_date)
        visits = Visit.where(user_id: user_id, location_id: location_id)
        if visits == nil
            return false
        else
            visits.each do |visit|
                #if (start_date>=visit.start_date.to_s && start_date<=visit.end_date.to_s) ||
                   #(visit.start_date.to_s>=start_date && visit.start_date.to_s<=end_date)
                if (start_date == visit.start_date.to_s)    
                    return true
                end
            end
            return false
        end
    end

end
