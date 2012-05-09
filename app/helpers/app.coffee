app.helpers ?= {}

app.helpers.pluralize = (count, word, plword, friendlyNum) ->
  # a bit naiive I suppose
  plword ||= if word.match(/s$/) then word else "#{word}s"
  if friendlyNum
    num = app.helpers.friendlyNumber(count)
  else
    num = count
  if count == 1
    "#{num} #{word}"
  else
    "#{num} #{plword}"

app.helpers.friendlyNumber = (num) ->
  str = num.toString()
  groups = []
  if str.length >= 5
    while part = str.match(/\d{3}$/)
      groups.unshift part[0]
      str = str.replace(/\d{3}$/, '')
    groups.unshift str if str
  else
    groups.push(str)
  groups.join(',')

app.helpers.sortCol = (label, sort, params) ->
  params = ("#{k}=#{v}" for k, v of params).join('&')
  "<a href='?sort=#{sort}&#{params}'>#{label}</a>"
