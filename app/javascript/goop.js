document.addEventListener('turbo:load', function () {
  const goopSrc = '/goop.gif'
  const goopHeight = 140
  const goopWidth = 93
  let container = document.getElementById('goop-gif-container')
  if (!container) {
    container = document.createElement('div')
    container.id = 'goop-gif-container'
    container.style.position = 'fixed'
    container.style.left = '0'
    container.style.right = '0'
    container.style.bottom = '0'
    container.style.height = goopHeight + 'px'
    container.style.zIndex = '9'
    container.style.pointerEvents = 'none'
    container.style.background = 'none'
    container.style.width = '100vw'
    container.style.overflow = 'visible'
    document.body.appendChild(container)
  }

  function spawnGoop() {
    const img = document.createElement('img')
    img.src = goopSrc
    img.alt = 'goop'
    img.style.position = 'absolute'
    img.style.height = goopHeight + 'px'
    img.style.width = goopWidth + 'px'
    img.style.left = Math.floor(Math.random() * (window.innerWidth - goopWidth)) + 'px'
    img.style.bottom = '0'
    img.style.pointerEvents = 'none'
    img.style.animation = 'goopDummy 1.4s linear 1'
    img.addEventListener('animationend', function () {
      img.remove()
    })
    container.appendChild(img)
  }

  setInterval(spawnGoop, 1000)
})
