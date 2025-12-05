import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tag","gameid"]

  connect() {
  }

  getValue(){
    let game_id = this.gameidTarget.innerHTML
    let course = this.tagTarget.value
    location.assign(`/scheduled/game/${game_id}/change_course?course=${course}`)
  }

  getPay(){
    let game_id = this.gameidTarget.innerHTML
    let pay = this.tagTarget.value
    location.assign(`/scheduled/game/${game_id}/change_pay?pay=${pay}`)
  }

}