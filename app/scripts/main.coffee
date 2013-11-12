do ($=jQuery)->
  $.getUrlParam = (key)->
    result = new RegExp("#{key}=([^&]*)", "i").exec(window.location.search)
    return result and unescape(result[1]) or ""

addSigners = (data) ->
  for s in data.signers
    $li = $("<li><img src='#{s.picture_url}' alt='#{s.name}' title='#{s.name}' /></li>")
    $('ul.signers').append($li)

SPECIAL_SIGNERS = [
  name: 'Aneesh Chopra'
  picture_url: 'https://pbs.twimg.com/profile_images/378800000040581867/a0962f4551be12d095b281f8afa81a95.jpeg'
,
  name: "Tim O'Reilly"
  picture_url: 'https://pbs.twimg.com/profile_images/2823681988/f4f6f2bed8ab4d5a48dea4b9ea85d5f1.jpeg'
,
  name: "Eric Reis"
  picture_url: 'https://pbs.twimg.com/profile_images/1769304611/image1327092761.png'
,
  name: "John Tolva"
  picture_url: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash1/273765_835915087_1942680115_n.jpg'
,
  name: 'Cheryl Contee'
  picture_url: 'https://pbs.twimg.com/profile_images/1780647236/Screen_shot_2011-03-31_at_8.33.24_AM.png'
,
  name: 'Janice Fraser'
  picture_url: 'https://pbs.twimg.com/profile_images/1207809084/janice_thumb.jpg'
]


$ ->
  if $.getUrlParam('signed')
    $('h1.signed').show()
    $('h1.not-signed').hide()

  addSigners(signers: SPECIAL_SIGNERS)

  initialSkip = 20 - SPECIAL_SIGNERS.length

  $.getJSON "/api?limit=#{initialSkip}", (data) ->
    $('.signers-count').text(data.count + SPECIAL_SIGNERS.length)
    addSigners(data)

  skip = initialSkip
  loading = false

  $('a.load-more').click ->
    return if loading
    loading = true
    $(@).data('original-text', $(@).text())
    $(@).text('Loading...')

    $.getJSON "/api?skip=#{skip}", (data) =>
      addSigners(data)
      skip = skip + data.signers.length
      loading = false
      $(@).text($(@).data('original-text'))
