// source: https://codepen.io/sarahwfox/pen/pNrYGb
function update_tiny(i) {
    if (tiny[i]) {
        if (--tinyv[i] === 25 && tiny[i].style) {
            tiny[i].style.width = "3px";
            tiny[i].style.height = "3px";
        }
        if (tinyv[i]) {
            tinyy[i] += 1 + Math.random()*3;
            tinyx[i] += (i%5-2)/5;
            if (tinyy[i] < shigh + sdown) {
                if (tiny[i].style) {
                    tiny[i].style.top = tinyy[i] + "px";
                    tiny[i].style.left = tinyx[i] + "px";
                    // Assign a random color for trailing sparkles
                    const randColor = colors[Math.floor(Math.random() * colors.length)];
                    if (tiny[i].childNodes.length === 2) {
                        tiny[i].childNodes[0].style.backgroundColor = randColor;
                        tiny[i].childNodes[1].style.backgroundColor = randColor;
                    }
                }
            } else {
                // Sparkle has reached bottom, start fade out and removal
                if (tiny[i] && tiny[i].style) {
                    tiny[i].style.transition = "opacity 1s linear";
                    tiny[i].style.opacity = "0";
                    setTimeout(() => {
                        if (tiny[i] && tiny[i].parentNode) {
                            tiny[i].parentNode.removeChild(tiny[i]);
                        }
                        tiny[i] = null;
                    }, 1000);
                }
                tinyv[i] = 0;
                return;
            }
        } else {
            // Sparkle animation finished, start fade out and removal
            if (tiny[i] && tiny[i].style) {
                tiny[i].style.transition = "opacity 1s linear";
                tiny[i].style.opacity = "0";
                setTimeout(() => {
                    if (tiny[i] && tiny[i].parentNode) {
                        tiny[i].parentNode.removeChild(tiny[i]);
                    }
                    tiny[i] = null;
                }, 1000);
            }
        }
    }
}
// Modern Sparkle Effect
const color = "random"; // "random" can be replaced with any valid color ie: "red"...
const sparkles = 1000; // increase or decrease for number of sparkles falling

let ox = 400, x = 400;
let oy = 300, y = 300;
let swide = 800;
let shigh = 600;
let sleft = 0, sdown = 0;
const tiny = [];
const star = [];
const starv = [];
const starx = [];
const stary = [];
const tinyx = [];
const tinyy = [];
const tinyv = [];

const colors = [
    '#6a0dad', // deep purple
    '#228b22', // forest green
    '#483d8b', // dark slate blue
    '#2e8b57', // sea green
    '#4b0082', // indigo
    '#8a2be2', // blue violet
    '#5f9ea0', // cadet blue (eerie teal)
    '#696969', // dim gray (smoky)
    '#191970', // midnight blue
    '#00ced1', // dark turquoise
    '#9400d3', // dark violet
];

function mouseMoveHandler(e) {
	x = e.pageX;
	y = e.pageY;
}

function scrollHandler() {
	sdown = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
	sleft = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft || 0;
}

function resizeHandler() {
	swide = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth || 800;
	shigh = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight || 600;
}

function createDiv(height, width, color) {
    const div = document.createElement("div");
    div.style.position = "absolute";
    div.style.height = height + "px";
    div.style.width = width + "px";
    div.style.overflow = "hidden";
    div.style.zIndex = "9999";
    div.style.backgroundColor = "transparent";

    // Original bar sizes: vertical 5x1, horizontal 1x5
    // For a container of 5x5px
    const vBar = document.createElement("div");
    vBar.style.position = "absolute";
    vBar.style.height = height + "px";
    vBar.style.width = "1px";
    vBar.style.left = Math.floor(width/2) + "px";
    vBar.style.top = "0px";
    vBar.style.backgroundColor = color;

    const hBar = document.createElement("div");
    hBar.style.position = "absolute";
    hBar.style.width = width + "px";
    hBar.style.height = "1px";
    hBar.style.left = "0px";
    hBar.style.top = Math.floor(height/2) + "px";
    hBar.style.backgroundColor = color;

    div.appendChild(vBar);
    div.appendChild(hBar);
    return div;
}

function newColor() {
	const arr = [255, Math.floor(Math.random()*256), Math.floor(Math.random()*(256-255/2))];
	arr.sort(() => 0.5 - Math.random());
	return `rgb(${arr[0]}, ${arr[1]}, ${arr[2]})`;
}

function sparkle() {
    if (Math.abs(x-ox)>1 || Math.abs(y-oy)>1) {
        ox = x;
        oy = y;
        for (let c=0; c<sparkles; c++) if (!starv[c]) {
            // Create new sparkle element if it doesn't exist
            if (!star[c]) {
                const starColor = colors[Math.floor(Math.random() * colors.length)];
                const starDiv = createDiv(5, 5, starColor); // main sparkle
                starDiv.style.visibility = "hidden";
                document.body.appendChild(star[c] = starDiv);
            }

            const randColor = colors[Math.floor(Math.random() * colors.length)];
            // update child colors for main sparkle
            star[c].childNodes[0].style.backgroundColor = randColor;
            star[c].childNodes[1].style.backgroundColor = randColor;
            star[c].style.left = (starx[c] = x) + "px";
            star[c].style.top = (stary[c] = y+1) + "px";
            star[c].style.clip = "rect(0px, 20px, 20px, 0px)";
            star[c].style.visibility = "visible";
            star[c].style.opacity = "1";
            star[c].style.transition = "";
            starv[c] = 50;
            break;
        }
    }
    for (let c=0; c<sparkles; c++) {
        if (starv[c]) update_star(c);
        if (tinyv[c]) update_tiny(c);
    }
    setTimeout(sparkle, 40);
}

function update_star(i) {
    if (!star[i]) return; // Exit early if star is null

    if (--starv[i] === 25 && star[i].style) star[i].style.clip = "rect(1px, 4px, 4px, 1px)";

    // Start trailing sparkle very early (when main sparkle has only taken a few steps)
    if (starv[i] === 40 && !tinyv[i]) {
        // Create new trailing sparkle element if it doesn't exist
        if (!tiny[i]) {
            const randColor = colors[Math.floor(Math.random() * colors.length)];
            const rats = createDiv(5, 5, randColor); // trailing sparkle
            rats.style.visibility = "hidden";
            document.body.appendChild(tiny[i] = rats);
        }

        tinyv[i] = 50;
        tiny[i].style.top = (tinyy[i] = stary[i]) + "px";
        tiny[i].style.left = (tinyx[i] = starx[i]) + "px";
        tiny[i].style.width = "5px";
        tiny[i].style.height = "5px";
        tiny[i].style.visibility = "visible";
        tiny[i].style.opacity = "1";
        tiny[i].style.transition = "";
        // update child colors for trailing sparkle
        const randColor = colors[Math.floor(Math.random() * colors.length)];
        if (tiny[i].childNodes.length === 2) {
            tiny[i].childNodes[0].style.backgroundColor = randColor;
            tiny[i].childNodes[1].style.backgroundColor = randColor;
        }
    }

    if (starv[i]) {
        stary[i] += 1 + Math.random()*3;
        starx[i] += (i%5-2)/5;
        if (stary[i] < shigh + sdown) {
            if (star[i] && star[i].style) {
                star[i].style.top = stary[i] + "px";
                star[i].style.left = starx[i] + "px";
            }
        } else {
            if (star[i] && star[i].style) {
                star[i].style.visibility = "hidden";
            }
            starv[i] = 0;
            return;
        }
    } else {
        // Hide the main sparkle and start fading it out
        if (star[i] && star[i].style) {
            star[i].style.transition = "opacity 1s linear";
            star[i].style.opacity = "0";
            setTimeout(() => {
                if (star[i] && star[i].parentNode) {
                    star[i].parentNode.removeChild(star[i]);
                }
                star[i] = null;
            }, 1000);
        }
    }
}

window.onresize=set_width;
function set_width() {
	var sw_min=999999;
	var sh_min=999999;
	if (document.documentElement && document.documentElement.clientWidth) {
		if (document.documentElement.clientWidth>0) sw_min=document.documentElement.clientWidth;
		if (document.documentElement.clientHeight>0) sh_min=document.documentElement.clientHeight;
	}
	if (typeof(self.innerWidth)=='number' && self.innerWidth) {
		if (self.innerWidth>0 && self.innerWidth<sw_min) sw_min=self.innerWidth;
		if (self.innerHeight>0 && self.innerHeight<sh_min) sh_min=self.innerHeight;
	}
	if (document.body.clientWidth) {
		if (document.body.clientWidth>0 && document.body.clientWidth<sw_min) sw_min=document.body.clientWidth;
		if (document.body.clientHeight>0 && document.body.clientHeight<sh_min) sh_min=document.body.clientHeight;
	}
	if (sw_min==999999 || sh_min==999999) {
		sw_min=800;
		sh_min=600;
	}
	swide=sw_min;
	shigh=sh_min;
}


function setupSparkles() {
    for (let i=0; i<sparkles; i++) {
        starv[i] = 0;
        tinyv[i] = 0;
        star[i] = null;
        tiny[i] = null;
    }
    resizeHandler();
    sparkle();
}

window.addEventListener("mousemove", mouseMoveHandler);
window.addEventListener("scroll", scrollHandler);
window.addEventListener("resize", resizeHandler);
window.addEventListener("DOMContentLoaded", setupSparkles);
