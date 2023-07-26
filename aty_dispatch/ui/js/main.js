function zeroPad(nr, base) {
    var len = String(base).length - String(nr).length + 1
    return len > 0 ? new Array(len).join("0") + nr : nr
}

function getRemaining(ms) {
    let remaining = ""

    let seconds = Math.floor(ms / 1000);
    let minutes = Math.floor(seconds / 60);
    let hours = Math.floor(minutes / 60);

    if (hours > 0) {
        remaining += zeroPad(hours, 24) + "h "
    }

    if (minutes > 0) {
        remaining += zeroPad(minutes % 60, 60) + "m "
    }

    if (seconds > 0) {
        remaining += zeroPad(seconds % 60, 60) + "s"
    }

    return remaining.trim()
}

$(function() {
    let dispatches = ''
    let dispatchId = 0;

    window.addEventListener("message", function(event){
        let data = event.data;

        switch(data.action){
            case "dispatch":
                dispatchId = dispatchId + 1;

                var random = Math.floor((Math.random() * 1000000) + 1);

                beep.currentTime = "0"
                beep.play()

                let dispatch = `
                <div class="dispatch ${random}" id="dis-${dispatchId}">   
                    <div class="header">
                        <img class="icon" src="assets/icons/patch.svg"/>
                        <div class="count">#${dispatchId}</div>
                        <div class="code">${data.code}</div>
                        <div class="title">${data.title}</div>
                    </div>
                    <div class="info-wrapper">
                        ${data.location ? 
                            `<div class="info location">
                                <img class="icon" src="assets/icons/location.svg" />
                                <div class="text">${data.location.road ? data.location.road + "," : ""} ${data.location.street ? data.location.street : ""}</div>
                            </div>` 
                            : ""
                        }
                        ${data.distance ? 
                            `<div class="info distance">
                                <img class="icon" src="assets/icons/distance.svg" />
                                <div class="text">${Math.round(data.distance)} Meters Away</div>
                            </div>` 
                            : ""
                        }
                        ${data.gender ? 
                            `<div class="info gender">
                                <img class="icon" src="assets/icons/gender.svg" />
                                <div class="text">${data.gender}</div>
                            </div>` 
                            : ""
                        }
                        ${data.weapon != "Fists" && data.weapon != null ? 
                            `<div class="info gender">
                                <img class="icon" src="assets/icons/weapon.svg" />
                                <div class="text">${data.weapon}</div>
                            </div>` 
                            : ""
                        }
                        ${data.vehicle ? 
                            `<div class="info vehicle">
                                <img class="icon" src="assets/icons/vehicle.svg" />
                                <div class="text">${data.vehicle}</div>
                            </div>` 
                            : ""
                        }
                        ${data.plate ? 
                            `<div class="info plate">
                                <img class="icon" src="assets/icons/plate.svg" />
                                <div class="text">${data.plate}</div>
                            </div>` 
                            : ""
                        }
                        ${data.primary ? 
                            `<div class="info paint">
                                <img class="icon" src="assets/icons/paint.svg" />
                                <div class="text">${data.primary ? data.primary + "," : ""} ${data.secondary ? data.secondary : ""}</div>
                            </div>` 
                            : ""
                        }
                        
                    </div>
                    <div class="time-sent">
                        <img src="assets/icons/clock.svg" class="icon">
                        <div class="time" data-time="${Date.now()}">Just Now</div>
                    </div>
                </div>
                `
                
                $(".container").prepend(dispatch)
                let remove = $("."+random)
                dispatches += dispatch

                setTimeout(function() {
                    remove.css("transform", "translateX(0px)")
                }, 100)
                
                setTimeout(function() {
                    remove.css("transform", "translateX(500px)")

                    setTimeout(function() {
                        remove.remove()
                    }, 600)
                }, 10000)
            break;

            case "showDispatch":
                const now = new Date()

                $(".showDispatch").show()

                $(".showDispatch").html(dispatches)
                $(".showDispatch>div").each((_, el) => {
                    const $el = $(el)
                    const timestamp = $el.find(".time").data("time")
                    const other = new Date(timestamp)

                    $el.find(".time").text(getRemaining(now - other) + " Ago")
                })

            break;
        }
    })

    $(window).on("keydown", function ({ originalEvent: { key } }) {
		if (key == "Escape") {
            $(".showDispatch").hide()
			$.post(`https://${GetParentResourceName()}/close`)
		}
	})
})

let beep = new Audio()
beep.src = "sounds/beep.mp3"