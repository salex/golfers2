import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = [ "scheduled","players","player",'update','updatep','form','formbtn' ]
  connect() {
    console.log("scheduler")
  }

  add_player(){
    /*
      When a player is clicked it will get the #scheduled targer
      It will clone the button anda add an new action and add a new scheduled target.
      I will add new classes that override some classes.
      It will add an 'R' to the players id.
      It winl then added the cloned button and hide the original button
    */
    let player = event.target 
    let scheduled = document.getElementById('scheduled')
    let clone = player.cloneNode(true)
    clone.dataset.action = "click->scheduler#remove_player"
    clone.dataset.schedulerTarget = "scheduled"
    clone.classList.add('btn-schedule','bg-amber-700', 'mb-1')
    player.id += 'R'
    scheduled.appendChild(clone)
    player.style.display = 'none'
    this.setPlayers()
  }

  remove_player(){
    /*
      When a scheduled player is clicked it will get the targer
      It will get the id of the target and append a "R" to it.
      I will get the hidden target by the id.
      It will 'R' to the players id. and display the target
      It winl then remove the cloned node
    */

    let player = event.target
    var pid = player.id 
    var sched = document.getElementById(pid += 'R')
    sched.id.replace('R','')
    sched.style.display = 'block'
    player.parentNode.removeChild(player)
    this.setPlayers()
  }

  update_player(){
    // just displays a hidded submit buttpn
    this.updatepTarget.style.display = 'block'
    this.setPlayers()
  }

  setPlayers(){
    /*
      called after an add or remove player button clicked
      It will then Toggle submit buttons (Update Player and Form Teams)
    */
    let updatep = this.updatepTarget.style.display
    let new_players = this.scheduledTargets.length 

    if (updatep == 'block' ) {
      // if update player button show if will remove other button
      // clicking the update button will add players and update players
      if (new_players > 0) {
        var alert = document.getElementById('alert')
        alert.innerHTML = "Will update player(s) and add player(s)"
        alert.classList.remove('hidden')
      }
      this.updateTarget.style.display = 'none'
      this.formbtnTarget.style.display = 'none'
      return
    }

    // let new_players = this.scheduledTargets.length 
    let curr_players = this.playersTargets.length
    let players = new_players + curr_players
    if (new_players > 0) {
      this.updateTarget.style.display = 'block'
      if (this.hasFormbtnTarget) {
        this.formbtnTarget.style.display = 'none'
      }
    }else{
      this.updateTarget.style.display = 'none'
      if (this.hasFormbtnTarget && curr_players > 0) {
        this.formbtnTarget.style.display = 'block' 
      }
    }

    // let pot = players * this.preferences['dues']
    // let side = pot/3
    // this.potTarget.innerHTML = `${pot}/${side}`
  }

  submit(){
    // console.log("GO-T A SUBMIT")
    var new_players = document.getElementById('new_players')
    var add_players = this.scheduledTargets
    var btn =  event.target

    for (var i = 0;  i < add_players.length; i++) {
      const pid = add_players[i].dataset.playerid
      var inputtag = document.createElement('input')
      inputtag.type = "hidden"
      inputtag.name = "add_players[]"
      inputtag.value = pid
      new_players.appendChild(inputtag)
    }
    // Rails.fire(this.formTarget,'submit')
    Turbo.navigator.submitForm(this.formTarget)
    btn.style.display = 'none'
  }


}
