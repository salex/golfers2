import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = [ ]
  connect() {
    // console.log("toggler")
  }
  toggle_me(){
    let q = event.target.children[0]
    // console.log(q.classList)
    q.classList.toggle('hidden')
  }
  toggle(){
    let idx = event.target.dataset.who ||= 0
    this.togglemeTargets[idx].classList.toggle('hidden')
  }
}
