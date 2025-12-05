import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal']
  connect(){
    document.addEventListener('autocomplete.change', function(e) {
      const { value, textValue } = e.detail
      location.assign(`/players/${value}`)
    })

    console.log("player")
  }

  openModal(){
    this.modalTarget.style.display = 'block'
  }

  closeModal(){
    this.modalTarget.style.display = 'none'
  }

}