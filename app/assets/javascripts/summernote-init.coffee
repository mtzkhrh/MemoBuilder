$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      lang: 'ja-JP',
      height: 300,
      fontNames: ['Helvetica', 'sans-serif', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
      fontNamesIgnoreCheck: ['Helvetica', 'sans-serif', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],