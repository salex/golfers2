import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "player","in","good","hole_status","par","btn"]

  connect() {
    // console.log(this.hole_statusTargets.length)
    // console.log(this.btnTargets.length)

  }
  toggle_player(){
    // toggle if player is in or out of gam
    let who = event.target.dataset.who
    if (this.inTargets[who].classList.contains('hidden')) {
      this.inTargets[who].classList.remove('hidden')
    }else{
      this.inTargets[who].classList.add('hidden')
      this.parTargets[who].innerHTML = ".................."
      this.btnTargets.forEach(element => {
        if(element.dataset['pidx'] == who){
          element.innerHTML='.'
          element.classList.remove('st-0','st-1','st-2','st-3','st-9')
          this.update_status(element.dataset.hole)
        }
      })
    }
    var whosIn = this.get_whosIn()
  }

  get_whosIn(){
    var whosIn = []
    this.inTargets.forEach(element => {
      if(!element.classList.contains('hidden')){
        whosIn.push(parseInt(element.dataset['who']))
      }
    })
    return whosIn
  }

  rotate(){
    // let get old and new values and classes
    var what = event.target
    let curr_val = what.innerHTML
    let new_val = this.rotate_skin(curr_val)
    let curr_class = this.get_class(curr_val)
    let new_class =  this.get_class(new_val)
    what.innerHTML = new_val 
    // update classes
    if (curr_class != '') {what.classList.remove(curr_class)}
    if (new_class != '') {what.classList.add(new_class)}
    // now replace par
    var hole = what.dataset.hole
    var pidx = parseInt(what.dataset.pidx)
    var ppar = this.parTargets[pidx].innerHTML
    // console.log(`hole ${hole} ${pidx} ${ppar}`)
    ppar = this.replace_at(ppar,hole-1, new_val)
    this.parTargets[pidx].innerHTML = ppar
    var in_players = this.inTargets[pidx]
    in_players.dataset.par = ppar
    this.update_status(hole)
  }

  update_status(hole){
    var skins = ''
    var status
    hole = parseInt(hole) - 1 
    this.inTargets.forEach(element => {
      if(!element.classList.contains('hidden')){
        skins += element.dataset.par[hole]
      }
    })
    skins = skins.replace(/B/g,'1')
    skins = skins.replace(/E/g,'2')
    skins = skins.replace(/A/g,'3')
    this.set_status(hole,skins)
  }

  set_status(hole,skins){
    let birdie
    let eagle
    let albatros
    let status
    var curr
    // skins is a string sorted by player
    albatros = (skins.match(/3/g)||[]).length
    eagle = (skins.match(/2/g)||[]).length
    birdie = (skins.match(/1/g)||[]).length

    if (albatros == 1) {
      status = 3
    } else if (eagle == 1) {
      status = 2
    } else if (birdie == 1) {
      status = 1
      // got a tie at least two the same
    } else if(albatros > 1 || eagle > 1 || birdie > 1){
      status = 9
    } else {
      status = 0
    }
    status = status.toString()
    this.hole_statusTargets[hole].classList.remove('st-0','st-1','st-2','st-3','st-9')
    this.hole_statusTargets[hole].classList.add(`st-${status}`)
    curr = this.goodTarget.innerHTML
    curr = curr.slice(0,hole) + status + curr.slice(hole + 1)
    this.goodTarget.innerHTML = curr
  }

  get_class(c){
    switch (c) {
      case '.': return 'st-0'
      case 'B': return 'st-1'
      case 'E': return 'st-2'
      case 'A': return 'st-3'
      default: return "?"
    }
  }

  replace_at(str,idx,char){
    return str.substring(0, idx) + char + str.substring(idx+1);
  }

  rotate_skin(curr_val) {
    let new_val;
    switch (curr_val) {
      case '.': return new_val = 'B'
      case 'B': return new_val = 'E'
      case 'E': return new_val = 'A'
      case 'A': return new_val = '.'
      default: return new_val = "?"
    }
  }

}
