class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def get_time
    time_res = (Time.now - updated_at).to_i
    res = 'second(s)'
    if time_res > 60
        time_res = time_res / 60
        res = 'minute(s)'
        if time_res > 60
            time_res = time_res / 60
            res = 'hour(s)'
            if time_res > 24
                time_res = time_res / 24
                res = 'day(s)'
                if time_res > 30
                    time_res = time_res / 30
                    res = 'month(s)'
                    if time_res > 12
                        time_res = time_res / 12
                        res = 'year(s)'
                    end
                end
            end
        end
    end
    time_res.to_s  + ' ' + res + ' ago'
end
end
