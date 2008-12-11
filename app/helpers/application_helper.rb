# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def distance_of_time_in_dutch(from_time, to_time = Time.now, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? '< min.' : '1 min.' unless include_seconds
        case distance_in_seconds
          when 0..4   then '< 5 sec.'
          when 5..9   then '< 10 sec.'
          when 10..19 then '< 20 sec.'
          when 20..59 then '< 1 min.'
          else             '1 min.'
        end

      when 2..44           then "#{distance_in_minutes} min."
      when 45..89          then '~ 1 uur'
      when 90..1439        then "~ #{(distance_in_minutes.to_f / 60.0).round} uren"
      when 1440..2879      then '1 dag'
      when 2880..43199     then "#{(distance_in_minutes / 1440).round} dagen"
      when 43200..86399    then '~ 1 maand'
      when 86400..525599   then "#{(distance_in_minutes / 43200).round} maanden"
      when 525600..1051199 then '~ 1 jaar'
      else                      "over #{(distance_in_minutes / 525600).round} jaren"
    end
  end
  

end
