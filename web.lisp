(progn ;;preamble
  ;; (let ((quicklisp-init "/Users/pico/Downloads/foolin/2024/09/web/web/ql/setup.lisp"))
  ;;   (when (probe-file quicklisp-init)
  ;;     (load quicklisp-init)))
  ;; (ql:quickload :parenscript)
  ;; (ql:quickload :cl-ppcre)
  ;; (defpackage :ngdcc (:use :cl :parenscript :cl-ppcre))
  (in-package :ngdcc)
  )
(defun write-index-html  (page code)
  (with-open-file
      (index-html
       "/Users/pico/Downloads/foolin/2024/09/web/web/index.html"
       :direction :output
       :if-exists :supersede
       :if-does-not-exist :create)
    (format index-html "<!DOCTYPE html>~%~a~%" (regex-replace-all "76b6" page code))))
(defmacro html-src (&rest code)
  `(define-symbol-macro html (ps-html ,@code)))
(defmacro js-src (&rest code)
  `(define-symbol-macro js (ps ,@code)))
(defpsmacro states (&rest body)
  (let ((i -1))
    `(progn
       ,@(mapcar (lambda (state)
		   `(var ,state ,(incf i)))
		 body))))
(defun splash ()
  (with-open-file (splsh
		   "/Users/pico/Downloads/foolin/2024/09/web/web/splash.b64"
		   :direction :input
		   :element-type 'character)
    (let ((str (make-string (file-length splsh))))
      (read-sequence str splsh)
      str)))
(defun drip ()
  (with-open-file (drp
		   "/Users/pico/Downloads/foolin/2024/09/web/web/drip.b64"
		   :direction :input
		   :element-type 'character)
    (let ((str (make-string (file-length drp))))
      (read-sequence str drp)
      str)))

(html-src
 ((:html :lang "en")
  (:head
   ((:meta :charset "utf-8"))
   ((:meta :name "viewport" :content "width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0"))
   (:title "NG Dreamcast Collab: Homebrew Edition")
   (:style "
:root {
}

@font-face { font-family: 'LeagueSpartanBold'; src: url('lsb.woff2') format('Woff2'); }

html, body {
  width: 100%;
  height: 100%;
  margin: 0px:
  padding: 0px;
  overflow: hidden;
  touch-action: none;
  background: #000000;
  font-family: 'LeagueSpartanBold';
}

a, a:visited {
  color: black;
}

#stage {
  width: 640px;
  height: 480px;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translateX(-50%) translateY(-50%);
  background: #000000;
  overflow: hidden;
}

#download {
  width: 161px;
  height: 34px;
  position: absolute;
  left: 443px;
  top: 31px;  
  /* background: #00ff00; */
}

#guide {
  position: absolute;
  top: 128px;
  left: 88px;
  width: 464px;
  height: 304px;
  overflow-y: auto;
  padding: 1em;
  box-sizing: border-box;
  /*(chain c (rnd 88 128 464 304 20))*/
  /* background: #00ff00; */
}

"))
  ((:body :id "body")
   ((:audio :id "menu" :preload "auto" :loop "true" :style "display: none;")
    ((:source :src "menu.mp3")))
   ((:div :id "stage")
    ((:canvas :id "cnv" :width "640" :height "480"))
    ((:a :id "download" :href "https://montrose-is-ng-dc-collab.s3.amazonaws.com/ngdcc20240930.zip" :download "ngdcc20240930.zip")))
   ((:script :type "text/javascript") "76b6"))
  
  ((:template :id "downloadit")
   ;;zip -9 -r ngdcc002.zip index.html lsb.woff2 menu.mp3 pngs
   (:p "To download, just click the \"Download Now\" button. This will download a compact disc image (cdi) file compatible with most emulators (see step 4) and certain disc burning software (see step 2)."))
  
  ((:template :id "burnit")
   (:p "Burning Dreamcast compatible disc in $CURRENT_YEAR is not for the faint of heart! You can fully enjoy the homebrew collab via emulation (see step 4).")
   (:p "If you do want to play on real hardware and don't have a " ((:a :target "_blank" :href "https://gdemu.wordpress.com/") "GDEMU") " or similar optical drive replacement, we recommend Disc Juggler Pro V 6.00.1400. Padus, Inc., the company who produced Disc Juggler, is no longer in business and Disc Juggler is effectively abondonware. However, it is available at " ((:a :target "_blank" :href "https://archive.org/details/disc-juggler-pro-v-6.00.1400") "The Internet Archive") "."   )
   (:p "The software can no longer be installed normally, but can run on Windows 10. First, unrar the archive you downloaded from the Internet Archive (ie using your--no doubt--registered copy of " ((:a :target "_blank" :href "https://www.rarlab.com/") "winrar") "). Next, find and rename " (:i "setup.exe") " to " (:i "setup.7z") ". This will allow you to right click it, and to select \"7-Zip->Open Archive\". Extract everything to a place you find convenient and run " (:i "Cdj.exe") ". Be forewarned that Disc Juggler will not launch if a compatible burner is not available.")
   (:p "You do not need to register Disc Juggler, the collab is designed to fit on a standard 700mb compact disc and should always be burned at the slowest possible speed, so the trial restrictions don't matter.")
   (:p "Once Disc Juggler opens, go to \"File->Open\" and select \"all files\" for the filetype. Find where you downloaded the collab and open it. Click the \"advanced\" tab and make sure the mode is set to \"Mode 1/DVD\" and the block size is 2352. Make sure the \"Add post-gap to 3rd party images\" setting is also checked and you're ready to burn!")
   (:p "Good luck!"))
  
  ((:template :id "printit")
   (:p "Whether you've managed to burn your own CDR or just want an interesting shelf piece, "((:a :target "_blank" :href "https://kittyhawkmontrose.newgrounds.com/") "KittyhawkMontrose") " has prepared a slew of " ((:a :target "_blank" :href "https://www.newgrounds.com/art/view/kittyhawkmontrose/ng-dreamcast-collab-diy-materials") "NG Dreamcast Collab DIY Materials!") " , everything from CD sleeves to " ((:a :target "_blank" :href "https://en.wikipedia.org/wiki/LightScribe") "LightScribe") " compatible designs."))
  
  ((:template :id "emulateit")
   (:p "We recommend the " ((:a :target "_blank" :href "https://github.com/flyinghead/flycast") "Flycast") " emulator. Some emulators will need you to \"open\" and \"close\" the disc tray at the start up screen in order to work properly (ie before \"pressing 'A' to continue\")."))
  
  ((:template :id "earnit")  
   (:p "There are three medals available. One of them requires you to enter a hidden code by clicking " ((:a :onclick "challenge()" :href "#") "here") ".")
   (:p "Happy hunting!"))
  
  ((:template :id "enjoyit")
   ((:script :type "text/javascript") (ps (unlock-trophy 80816)))
   (:p "In the spirit of being a true demo disc, the homebrew version of the collab is just a sampler. Be sure to check out " ((:a :target "_blank" :href "https://www.newgrounds.com/portal/view/947362") "the full collab") "!"))))
(js-src
 
 (states
  st-init
  st-stall
  st-boot
  st-tmp
  st-menu-init
  st-menu-still
  st-menu-move
  st-menu-prime
  st-menu-guide
  )
 
 (progn ;;resize
   (var resize-timer 0)
   (setf (@ cnv rect) null)
   (defun resize ()
     ;;(return-from resize )
     (setf (@ cnv rect) null)
     (let ((scale 1)
	   (target-width 640)
	   (rect (chain body (get-bounding-client-rect))))       
       (with-slots (width height) rect
	 (if (>= height (* width (/ 3 4)))
	     (setf target-width width)
	     (setf target-width (* height (/ 4 3))))
	 (setf scale (/ target-width 640))
	 (setf (@ stage style transform) (concatenate 'string "translateX(-50%) translateY(-50%) scale(" scale ")")))))
   (setf (@ window onresize)
	 (lambda ()
	   (clear-timeout resize-timer)
	   (set-timeout resize 250)))
   (resize))
 
 (progn ;;pointerstuff
   ;; (setf (@ tv onpointermove)
   ;;       (lambda (e)	 
   ;; 	 ))

   ;; (setf (@ tv onpointerdown)
   ;;       (lambda (e)	 
   ;; 	 ))
   ) 
 (setf (@ document onkeydown)
       (lambda (e)
	 (when (eql state st-menu-still)
	   (cond
	   ((or (eql (@ e key) "ArrowLeft")
		(eql (@ e key) "a")
		(eql (@ e key) "A"))
	    ;;(nav-left)
	    (when (> cur 1)
	      (setf polarity 1)
	    (setf state st-menu-prime))
	    	    
	    )
	   ((or (eql (@ e key) "ArrowRight")
		(eql (@ e key) "d")
		(eql (@ e key) "D"))
	    (when (< cur tp)
	      (setf polarity -1)
	    (setf state st-menu-prime))
	    
	    ;;(nav-right)
	    ))
	   )
	 ))

 (progn ;;globals

   (progn ;;resources
     (var id "59068:bPYPw2Pv")
     (var guide null)
     (var active false)
     (var cur 1)
     (var tp 6)
     (var nxt 2)
     (var thumb null)
     (var thumbs (list
		  ""
		  "pngs/download.png"
		  "pngs/burn.png"
		  "pngs/print.png"
		  "pngs/emulate.png"
		  "pngs/earn.png"
		  "pngs/enjoy.png"
		  ""))
     (var txt (list
	       ""
	       "pngs/01.png"
	       "pngs/02.png"
	       "pngs/03.png"
	       "pngs/04.png"
	       "pngs/05.png"
	       "pngs/06.png"
	       ""))
     (var titles (list
		  ""
		  "Download It!"
		  "Burn It!"
		  "Encase It!"
		  "Emulate It!"
		  "Earn It!"
		  "Explore It!"
		  ""
		  ))
     (var guides (list
		  ""
		  "downloadit"
		  "burnit"
		  "printit"
		  "emulateit"
		  "earnit"
		  "enjoyit"
		  "")))

   (progn ;;gfx
     (var c null))

   (progn ;;anim
     (var polarity 0)
     (var offsets (list -412 0 412))
     (var textures (list 0 1 2))
     (var para-offsets (list 29 149 269))
     (var offset 0)
     (var para-offset 0)
     (var texture 0)
     (var anim-offsets (list
			0.0 0.2919646916744447 1.167031161055182 2.622718745410405
			4.654901714794723 7.257819368242853 10.424091936811273 14.144747057924741
			18.40923685942746 23.20547095566834 28.51986056052438 34.33733212687056
			40.641399856884966 47.414200352329004 54.63652348089635 62.287909456711404
			70.34665615861755 78.78992674984585 87.59378787826202 96.73330040969616
			106.18252528683774 115.91469345540236 125.90221804543351 136.11678835192893
			146.52945008455725 157.11070617776292 167.8305257292112 178.65854073153716
			189.56405801991028 200.5161647409939 211.48383525900607 222.4359227544649
			233.34145926846284 244.1694932239274 254.88929382223702 265.4705499154427
			275.8831935046795 286.09778195456647 296.08532388973106 305.8174747131622
			315.2667159406526 324.40619633904055 333.2100732501541 341.6533583562985
			349.7120905432886 357.36348306044164 364.58579349272725 371.358600143115
			377.66265721121204 383.4801394394756 388.7945334909026 393.5907591557375
			397.8552546979766 401.57590200555535 404.7421806317572 407.34510134292503
			409.3772797206517 410.8329696077301 411.7080344742921 412.0))
     (var anim-para-offsets (list
		     0.0 5.3333335 10.666667 16.0 21.333334 26.666666 32.0 37.333332 42.666668 48.0 53.333332 58.666668
		     64.0 69.333336 74.666664 80.0 85.333336 90.666664 96.0 101.333336 106.666664 112.0 117.333336 122.666664
		     128.0 133.33333 138.66667 144.0 149.33333 154.66667 160.0 165.33333 170.66667 176.0 181.33333 186.66667
		     192.0 197.33333 202.66667 208.0 213.33333 218.66667 224.0 229.33333 234.66667 240.0 245.33333 250.66667
		     256.0 261.33334 266.66666 272.0 277.33334 282.66666 288.0 293.33334 298.66666 304.0 309.33334 314.66666
		     320.0 325.33334 330.66666 336.0 341.33334 346.66666 352.0 357.33334 362.66666 368.0 373.33334 378.66666
		     384.0 389.33334 394.66666 400.0 405.33334 410.66666 416.0 421.33334 426.66666 432.0 437.33334 442.66666
		     448.0 453.33334 458.66666 464.0 469.33334 474.66666 480.0 485.33334 490.66666 496.0 501.33334 506.66666
		     512.0 517.3333 522.6667 528.0 533.3333 538.6667 544.0 549.3333 554.6667 560.0 565.3333 570.6667
		     576.0 581.3333 586.6667 592.0 597.3333 602.6667 608.0 613.3333 618.6667 624.0 629.3333 634.6667
		     640.0 645.3333 650.6667 656.0 661.3333 666.6667 672.0 677.3333 682.6667 688.0 693.3333 698.6667
		     704.0 709.3333 714.6667 720.0 725.3333 730.6667 736.0 741.3333 746.6667 752.0 757.3333 762.6667
		     768.0 773.3333 778.6667 784.0 789.3333 794.6667 800.0 805.3333 810.6667 816.0 821.3333 826.6667
		     832.0 837.3333 842.6667 848.0 853.3333 858.6667 864.0 869.3333 874.6667 880.0 885.3333 890.6667
		     896.0 901.3333 906.6667 912.0 917.3333 922.6667 928.0 933.3333 938.6667 944.0 949.3333 954.6667
		     960.0 -954.6667 -949.3333 -944.0 -938.6667 -933.3333 -928.0 -922.6667 -917.3333 -912.0 -906.6667 -901.3333
		     -896.0 -890.6666 -885.3334 -880.0 -874.6666 -869.3334 -864.0 -858.6666 -853.3334 -848.0 -842.6666 -837.3334
		     -832.0 -826.6666 -821.3334 -816.0 -810.6666 -805.3334 -800.0 -794.6666 -789.3334 -784.0 -778.6666 -773.3334
		     -768.0 -762.6666 -757.3334 -752.0 -746.6666 -741.3334 -736.0 -730.6666 -725.3334 -720.0 -714.6666 -709.3334
		     -704.0 -698.6666 -693.3334 -688.0 -682.6666 -677.3334 -672.0 -666.6666 -661.3334 -656.0 -650.6666 -645.3334
		     -640.0 -634.6666 -629.3334 -624.0 -618.6666 -613.3334 -608.0 -602.6666 -597.3334 -592.0 -586.6666 -581.3334
		     -576.0 -570.6666 -565.3334 -560.0 -554.6666 -549.3334 -544.0 -538.6666 -533.3334 -528.0 -522.6666 -517.3334
		     -512.0 -506.66663 -501.33337 -496.0 -490.66663 -485.33337 -480.0 -474.66663 -469.33337 -464.0 -458.66663 -453.33337
		     -448.0 -442.66663 -437.33337 -432.0 -426.66663 -421.33337 -416.0 -410.66663 -405.33337 -400.0 -394.66663 -389.33337
		     -384.0 -378.66663 -373.33337 -368.0 -362.66663 -357.33337 -352.0 -346.66663 -341.33337 -336.0 -330.66663 -325.33337
		     -320.0 -314.66663 -309.33337 -304.0 -298.66663 -293.33337 -288.0 -282.66663 -277.33337 -272.0 -266.66663 -261.33337
		     -256.0 -250.66663 -245.33337 -240.0 -234.66663 -229.33337 -224.0 -218.66663 -213.33337 -208.0 -202.66663 -197.33337
		     -192.0 -186.66663 -181.33337 -176.0 -170.66663 -165.33337 -160.0 -154.66663 -149.33337 -144.0 -138.66663 -133.33337
		     -128.0 -122.666626 -117.333374 -112.0 -106.666626 -101.333374 -96.0 -90.666626 -85.333374 -80.0 -74.666626 -69.333374
		     -64.0 -58.666626 -53.333374 -48.0 -42.666626 -37.333374 -32.0 -26.666626 -21.333374 -16.0 -10.666626 -5.333374)))

   (progn ;;sfx
     (var ac null)
     (var drip null))
   
   (progn ;;util
     (var node)
     (var loaded 0)
     (var bytes null))   

   (progn ;;tx
     (var splash (new (-image)))
     (var ng (new (-image)))
     (var cvr (new (-image)))
     (var bg (new (-image)))
     (var flr (list (new (-image)) (new (-image)) (new (-image))))
     (var stp (list (new (-image)) (new (-image)) (new (-image))))
     (var blr (new (-image)))
     (var blrp ""))
   
   (progn ;;states
     (var lst 0)
     (var delta 0)
     (var sb-st 0)
     (var sb-tm 0)
     (var frm 0)
     (var state st-init))
   
   )

 (defun handle-click (e)
   (when (not (eql "running" (@ ac state)))
     (chain ac (resume)))
   (let ((x 0)
	 (y 0))
     (when (null (@ cnv rect))
       (setf (@ cnv rect) (chain cnv (get-bounding-client-rect))))
     (with-slots (left top width height) (@ cnv rect)	             
       (setf x (/ (- (@ e client-x) left) width))
       (setf y (/ (- (@ e client-y) top) height))       
       (cond
     ((and (eql state st-stall) (eql sb-st 1))
      (play drip)
      (setf (@ menu muted) 1)
      (chain menu (play))
      (setf sb-st 2))
     ((eql state st-menu-still)
	  (when (> y 0.2)
	    (cond
	      ((and (< x 0.2) (> cur 1))
	       (setf polarity 1)
	       (setf state st-menu-prime))
	      ((and (> x 0.8) (< cur tp))
	       (setf polarity -1)
	       (setf state st-menu-prime))
	      (t
	       (setf sb-st 0)
	       (setf state st-menu-guide)))
	    ))
     ((eql state st-menu-guide)
      (when (not
	     (and
	      (> x (lisp (/ 88 640.0)))
	      (< x (lisp (+ (/ 464 640.0) (/ 88 640.0))))
	      (> y (lisp (/ 128 480.0)))
	      (< y (lisp (+ (/ 304 480.0) (/ 128 480.0))))))
	(setf sb-st 2)))))))

 (defun dl (e)
   ;;(alert "dl")   
   (chain console (log "dl"))
   (return-from dl true)
   )

 (defun play (buf)
   (let ((src (chain ac (create-buffer-source))))
     (setf (@ src buffer) buf)
     (chain src (connect (@ ac destination)))
     (chain src (start 0))))

 (defun rnd (x y w h r)
   (chain c (begin-path))
   (chain c (move-to (+ x r) y))
   (chain c (arc-to (+ x w) y (+ x w) (+ y h) r))
   (chain c (arc-to (+ x w) (+ y h) x (+ y h) r))
   (chain c (arc-to x (+ y h) x y r))
   (chain c (arc-to x y (+ x w) y r))
   (chain c (close-path)))

 (defun load ()
   (setf loaded (+ loaded 1)))

 (setf json -j-s-o-n)
 (defparameter *session* nil)

 (defun ng-post (call- call-back)
   (chain
    (fetch
     "https://www.newgrounds.io/gateway_v3.php/"
     (create
      headers (create "Content-Type" "application/x-www-form-urlencoded")
      method "POST"
      body
      (concatenate 'string "input="
		   (encode-u-r-i-component
		    (chain json (stringify (create
					    app_id "59068:bPYPw2Pv"
					    session_id *session*
					    call call-)))))))
    (then #'(lambda (rsp)
	      (when (@ rsp ok)
		(chain (chain rsp (json)) (then call-back)))))))
 
 (defmacro ng-call (call &rest body)
   `(ng-post ,call #'(lambda (data) ,@body)))

 (defun ping ()
   (symbol-macrolet ((ms-five-minutes (lisp (* 1000 60 5))))
     (set-timeout #'ping ms-five-minutes)
     (setf *session* (chain (new (-u-r-l-Search-Params (@ document location search))) (get "ngio_session_id")))
     (ng-call (create component "Gateway.ping" parameters (create)))))
 (ping)

 (defun unlock-trophy (trophy)
   (ng-call (create component "Medal.unlock" parameters (create id trophy))))

 (defun challenge ()
   (unlock-trophy (+ 77709 (parse-int (prompt "Code:")))))

 (defun main (now)
   (setf delta (- now lst))   
   (request-animation-frame #'main)
   (cond
     
     ((eql state st-init)
      (setf loaded 0)
      (setf c (chain cnv (get-context "2d")))
      (setf ac (new (-audio-context)))

      (setf (@ c fill-style) "#000000")
      (setf (@ c rnd) #'rnd)      

      (setf (@ splash src) (splash-string))
      (setf (@ splash onload) #'load)

      (setf drip (atob (drip-string)))
      (setf bytes (new (-uint8-array 2451)))
      (loop for i from 0 to 2450
	    do (setf (aref bytes i) (chain drip (char-code-at i))))
      (setf drip (@ bytes buffer))
      (setf bytes null)

      (chain
       (chain ac (decode-audio-data drip))
       (then
	#'(lambda (buf)
	    (setf drip buf)
	    (load))))

      (setf (@ stage onpointerdown) #'handle-click)
      (setf (@ download onpointerdown) #'dl)
      ;;(setf (@ stage onpointermove) #'handle-move)

      (unlock-trophy 80815)
      
      (setf sb-st 0)
      (setf state st-stall))

     ((eql state st-stall)
      (cond
	((eql sb-st 0)	 
	 (when (> loaded 1)
	   (chain c (draw-image splash 0 0))
	   (setf sb-st 1)))
	
	((eql sb-st 1)
	 ;;click will take to sb-st-2
	 )
	
	((eql sb-st 2)	 
	 (setf sb-st 0)
	 (setf state st-boot))))

     ((eql state st-boot)
      (cond
	((eql sb-st 0)
	 (chain c (fill-rect 0 0 640 480))
	 (setf loaded 0)
	 (setf sb-tm 0)
	 (setf (@ ng src) "pngs/ng.png")
	 (setf (@ ng onload) #'load)
	 (setf (@ (aref flr 0) src) "pngs/flr01.png")
	 (setf (@ (aref flr 0) onload) #'load)
	 (setf (@ (aref flr 1) src) "pngs/flr02.png")
	 (setf (@ (aref flr 1) onload) #'load)
	 (setf (@ (aref flr 2) src) "pngs/flr03.png")
	 (setf (@ (aref flr 2) onload) #'load)
	 (setf sb-st 1))

	((eql sb-st 1)
	 (setf sb-tm (+ sb-tm delta))
	 (when (and (> loaded 3) (> sb-tm (* 1 1250)))
	   (chain c (draw-image ng 0 0))
	   (setf loaded 0)
	   (setf sb-tm 0)
	   (setf (@ bg src) "pngs/bg.png")
	   (setf (@ bg onload)  #'load)	   
	   (setf sb-st 2)))

	((eql sb-st 2)
	 (setf sb-tm (+ sb-tm delta))
	 (when (and (> loaded 0) (> sb-tm (* 1 4000)))
	   (chain c (fill-rect 0 0 640 480))
	   (setf loaded 0)
	   (setf sb-tm 0)
	   (setf (@ cvr src) "pngs/cvr.png")
	   (setf (@ cvr onload) #'load)
	   (setf sb-st 3)))

	((eql sb-st 3)
	 (setf sb-tm (+ sb-tm delta))
	 (when (and (> loaded 0) (> sb-tm (* 1 1250)))
	   (chain c (draw-image cvr 0 0))
	   (setf loaded 0)
	   (setf sb-tm 0)
	   (setf (@ (aref stp 1) src) "pngs/download.png")
	   (setf (@ (aref stp 1) onload) #'load)
	   (setf (@ (aref stp 2) src) "pngs/burn.png")
	   (setf (@ (aref stp 2) onload) #'load)
	   (setf sb-st 4)))

	((eql sb-st 4)
	 (setf sb-tm (+ sb-tm delta))
	 (when (and (> loaded 1) (> sb-tm (* 1 4000)))
	   (chain c (fill-rect 0 0 640 480))
	   (setf loaded 0)
	   (setf sb-tm 0)
	   (setf (@ blr src) "pngs/01.png")
	   (setf (@ blr onload) #'load)	   	   
	   (setf sb-st 5)))

	((eql sb-st 5)
	 (setf sb-tm (+ sb-tm delta))
	 (when (and (> loaded 0) (> sb-tm (* 1 1250)))
	   (chain c (draw-image bg 0 0))
	   (setf (@ menu muted) 0)
	   (setf state st-menu-init)))	
	
	))

     ((eql state st-tmp)
      )

     ((eql state st-menu-init)
      (setf active true)
      (setf sb-tm 0)
      (setf polarity 0)
      (setf (aref offsets 0) -412)
      (setf (aref offsets 1) 0)
      (setf (aref offsets 2) 412)
      (setf state st-menu-still))

     ((eql state st-menu-still)
      (setf sb-tm (+ sb-tm delta))
      (loop while (>= sb-tm 32)
	    do (progn
		 (setf sb-tm (- sb-tm 32))
		 (chain c (draw-image bg 0 0))
		 (chain c (draw-image blr 0 382))

		 (chain c (save))
		 (chain c (translate 220 132))
		 (loop for i from 0 to 2
		       do (chain c (draw-image (aref flr i) (aref anim-para-offsets (mod (+ para-offset (aref para-offsets i)) 360)) 0)))
		 (chain c (restore))

		 
		 (chain c (save))
		 (chain c (translate 146 113))
		 (loop for i from 0 to 2
		       do (chain c (draw-image (aref stp (aref textures i)) (aref offsets i) 0)))		 
		 (chain c (restore))


		 


		 )))

     ((eql state st-menu-prime)
      (setf cur (- cur polarity))
      (setf nxt (- cur polarity))
      (setf thumb (new (-image)))
      (setf (@ thumb src) (aref thumbs nxt))
      (setf blrp (new (-image)))
      (setf (@ blrp src) (aref txt cur))
      (play drip)
      (setf sb-tm 0)
      (setf frm 0)
      (setf state st-menu-move))

     ((eql state st-menu-move)
      (setf sb-tm (+ sb-tm delta))
      (loop while (>= sb-tm 32)
	    do (progn
		 (setf sb-tm (- sb-tm 32))
		 (chain c (draw-image bg 0 0))

		 (chain c (save))
		 (chain c (translate 220 132))
		 (loop for i from 0 to 2		       
		       do (chain c (draw-image (aref flr i) (aref anim-para-offsets (mod (+ para-offset (aref para-offsets i)) 360)) 0)))
		 (chain c (restore))


		 (chain c (save))
		 (chain c (translate 146 113))
		 (loop for i from 0 to 2
		       do (progn
			    (setf offset (+ (aref offsets i) (* polarity (aref anim-offsets frm))))
			    (when (> (- (* polarity offset) 500) 0)
			      (setf (aref stp (aref textures i)) thumb)
			      (setf (aref offsets i) (* -2 (aref offsets i)))
			      (setf offset (+ (aref offsets i) (* polarity (aref anim-offsets frm)))))
			    (chain c (draw-image (aref stp (aref textures i)) offset 0))))		 
		 (chain c (restore))


		 (setf para-offset (+ para-offset polarity))
		 (when (< para-offset 0) (setf para-offset 359))
		 (when (> para-offset 359) (setf para-offset 0))

		 (when (> frm 58)
		   (if (> polarity 0)
		       (progn
			 (setf texture (aref textures 2))
			 (setf (aref textures 2) (aref textures 1))
			 (setf (aref textures 1) (aref textures 0))
			 (setf (aref textures 0) texture))
		       (progn
			 (setf texture (aref textures 0))
			 (setf (aref textures 0) (aref textures 1))
			 (setf (aref textures 1) (aref textures 2))
			 (setf (aref textures 2) texture)))		   
		   ;;(setf (@ blr src) )
		   (setf blr blrp)
		   (setf (aref offsets 0) -412)
		   (setf (aref offsets 1) 0)
		   (setf (aref offsets 2) 412)
		   (setf state st-menu-still))
		 
		 (setf frm (+ frm 1)))))

     ((eql state st-menu-guide)
      (cond 
	((eql sb-st 0)
	 (play drip)
	 
	 (setf (@ c fill-style) "#f86800")
	 (chain c (rnd 80 80 480 360 20))
	 (chain c (fill))

	 (setf (@ c fill-style) "#ffffff")
	 (setf (@ c stroke-style) "#000000")
	 (setf (@ c line-width) 3)
	 (chain c (rnd 88 128 464 304 20))
	 (chain c (fill))
	 (chain c (stroke))

	 (setf (@ c font) "28px LeagueSpartanBold")
	 (chain c (fill-text (aref titles cur) 110 116))

	 (chain c (fill-text "Back" 483 116))

	 (setf guide (chain document (create-Element "div")))
	 (setf (@ guide id) "guide")
	 (setf node (chain document (get-element-by-id (aref guides cur))))
	 (chain guide (append-child (chain node content (clone-node true))))
	 
	 (chain stage (append-child guide))
	 
	 (setf sb-st 1))

	((eql sb-st 1))

	((eql sb-st 2)
	 (play drip)
	 (chain stage (remove-child guide))
	 (setf state st-menu-still))

	))
     
     )
   (setf lst now))
 (request-animation-frame #'main)

 (defun splash-string () (lisp (splash)))
 (defun drip-string () (lisp (drip)))
 
 )
(write-index-html html js)
