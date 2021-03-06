@series.each do |serie|
  json.serie do |json|
    json.rank "#{serie.url[:rank]}位"
    json.name serie.name
    json.authors serie.authors.map{|a| a.name}.join("・")
    json.ranking "（#{serie.url[:sum_of_mark]}点： 得票数#{serie.url[:count_rank]}, クソ修正後得点#{serie.url[:sum_of_mark_with_kuso]}点, クソ得票数#{serie.url[:count_kuso]}）"
    json.magazine serie.magazines_series.map{|ms| ms.magazine ? (ms.magazine.name + (ms.placed ? (ms.placed != "" ? "（#{ms.placed}）" : "") : "")) : nil}.compact.uniq.join("　")
    json.detail do |json|
      json.content raw serie.post.content.gsub(/[\r\n]/, "") if serie.post
      json.by serie.post.user.name if serie.post
    end
    if serie.topic
      json.comments raw (serie.topic.posts - [serie.post]).map{|post| "#{post.content.gsub(/[\r\n]/, "")}（#{post.user.name}#{(rank = serie.ranks.where(ranking_id: @ranking_ids, user_id: post.user.id).first) ? ":#{rank.ranking_id == @ranking_ids[0] ? nil : "糞"}#{rank.rank}位" : nil}）"}.join("\n")
    end
  end
end
