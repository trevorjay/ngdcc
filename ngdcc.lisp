(progn ;;preamble
  ;; (let ((quicklisp-init "/Users/pico/Downloads/foolin/2024/09/ngdcc/ngdcc/ql/setup.lisp"))
  ;;   (when (probe-file quicklisp-init)
  ;;     (load quicklisp-init)))
 
  ;; (ql:quickload :uiop)
  ;; (ql:quickload :net.didierverna.clon.core)
  ;; (ql:quickload :c-mera)
  ;; (ql:quickload :cmu-c)

  ;; (defpackage :ngdcc
  ;;   (:use :cl :uiop)
  ;;   (:local-nicknames (:c :cmu-c)))
  (in-package :ngdcc)
  )
(setf (readtable-case *readtable*) :invert)
(defmacro codestring (&body body)
  `(with-output-to-string (*standard-output*)
     (c:simple-print (c:progn ,@body))))
(defmacro def-c-src (&rest body)
  `(define-symbol-macro c-src (codestring (c:progn ,@body))))
(defun compile-c (c-src)
  (with-open-file
      (cfile
       "/Users/pico/Downloads/foolin/2024/09/ngdcc/ngdcc/ngdcc.c"
       :direction :output
       :if-exists :supersede
       :if-does-not-exist :create)
    (format cfile "~a~%" c-src)))
(defmacro frame_a () '(c:progn (frame_x 0)))
(defmacro frame_b () '(c:progn (frame_x 1)))
(defmacro states (&rest body)
  (let ((i -1))
    `(progn
       ,@(mapcar (lambda (state)
		   `(define-symbol-macro ,state ,(incf i)))
		 body))))
(defmacro define-symbol-macros (bindings)
  "Define multiple symbol macros."
  `(progn
     ,@ (mapcar (lambda (binding)
		  `(define-symbol-macro ,(first binding) ,(second binding)))
		bindings)))

(define-symbol-macros ;;sizes
    ((tv_sz (* 320 320 2))
     (grd_sz (* 607 1024 2))
     (lgo_sz (* 607 1024 2))
     (cd_sz (* 385 512 2 3))
     (flr_sz (* 241 256 2 3))
     (blr_sz (* 98 640 2))))

(states
 st-init
 st-boot
 st-stall
 st-menu-init
 st-menu-still
 st-menu-move
 st-menu-prime
 st-spool
 st-unspool
 st-project
 )

(def-c-src
    (c:include <kos.h>)
    (c:include <kos/fs.h>)
  (c:include <dc/pvr.h>)
  (c:include <dc/syscalls.h>)
  (c:include <dc/sound/sound.h>)
  (c:include <dc/sound/sfxmgr.h>)
  (c:include <dc/vmu_fb.h>)
  (c:include <jpeg/jpeglib.h>)
  (c:include <zlib/zlib.h>)

  (c:progn ;;globals

    (c:decl ((int cur = 1)
	     (int top = 29)
	     (char (c:dref (c:aref covers ())) =
		   (c:clist
		    "/cd/cds/00.crp.gz"
		    "/cd/cds/01.crp.gz"
		    "/cd/cds/02.crp.gz"
		    "/cd/cds/03.crp.gz"
		    "/cd/cds/04.crp.gz"
		    "/cd/cds/05.crp.gz"
		    "/cd/cds/06.crp.gz"
		    "/cd/cds/07.crp.gz"
		    "/cd/cds/08.crp.gz"
		    "/cd/cds/09.crp.gz"
		    "/cd/cds/10.crp.gz"
		    "/cd/cds/11.crp.gz"
		    "/cd/cds/12.crp.gz"
		    "/cd/cds/13.crp.gz"
		    "/cd/cds/14.crp.gz"
		    "/cd/cds/15.crp.gz"
		    "/cd/cds/16.crp.gz"
		    "/cd/cds/17.crp.gz"
		    "/cd/cds/18.crp.gz"
		    "/cd/cds/19.crp.gz"
		    "/cd/cds/20.crp.gz"
		    "/cd/cds/21.crp.gz"
		    "/cd/cds/22.crp.gz"
		    "/cd/cds/23.crp.gz"
		    "/cd/cds/24.crp.gz"
		    "/cd/cds/25.crp.gz"
		    "/cd/cds/26.crp.gz"
		    "/cd/cds/27.crp.gz"
		    "/cd/cds/28.crp.gz"
		    "/cd/cds/29.crp.gz"
		    "/cd/cds/30.crp.gz"))
	     (char (c:dref (c:aref titles ())) =
		   (c:clist
		    "/cd/cds/00.tex.gz"
		    "/cd/cds/01.tex.gz"
		    "/cd/cds/02.tex.gz"
		    "/cd/cds/03.tex.gz"
		    "/cd/cds/04.tex.gz"
		    "/cd/cds/05.tex.gz"
		    "/cd/cds/06.tex.gz"
		    "/cd/cds/07.tex.gz"
		    "/cd/cds/08.tex.gz"
		    "/cd/cds/09.tex.gz"
		    "/cd/cds/10.tex.gz"
		    "/cd/cds/11.tex.gz"
		    "/cd/cds/12.tex.gz"
		    "/cd/cds/13.tex.gz"
		    "/cd/cds/14.tex.gz"
		    "/cd/cds/15.tex.gz"
		    "/cd/cds/16.tex.gz"
		    "/cd/cds/17.tex.gz"
		    "/cd/cds/18.tex.gz"
		    "/cd/cds/19.tex.gz"
		    "/cd/cds/20.tex.gz"
		    "/cd/cds/21.tex.gz"
		    "/cd/cds/22.tex.gz"
		    "/cd/cds/23.tex.gz"
		    "/cd/cds/24.tex.gz"
		    "/cd/cds/25.tex.gz"
		    "/cd/cds/26.tex.gz"
		    "/cd/cds/27.tex.gz"
		    "/cd/cds/28.tex.gz"
		    "/cd/cds/29.tex.gz"
		    "/cd/cds/30.tex.gz"))
	     (char (c:dref (c:aref videos ())) =
		   (c:clist
		    ""
		    "/cd/mlf/01.mlf"
		    "/cd/mlf/02.mlf"
		    "/cd/mlf/03.mlf"
		    "/cd/mlf/04.mlf"
		    "/cd/mlf/05.mlf"
		    "/cd/mlf/06.mlf"
		    "/cd/mlf/07.mlf"
		    "/cd/mlf/08.mlf"
		    "/cd/mlf/09.mlf"
		    "/cd/mlf/10.mlf"
		    "/cd/mlf/11.mlf"
		    "/cd/mlf/12.mlf"
		    "/cd/mlf/13.mlf"
		    "/cd/mlf/14.mlf"
		    "/cd/mlf/15.mlf"
		    "/cd/mlf/16.mlf"
		    "/cd/mlf/17.mlf"
		    "/cd/mlf/18.mlf"
		    "/cd/mlf/19.mlf"
		    "/cd/mlf/20.mlf"
		    "/cd/mlf/21.mlf"
		    "/cd/mlf/22.mlf"
		    "/cd/mlf/23.mlf"
		    "/cd/mlf/24.mlf"
		    "/cd/mlf/25.mlf"
		    "/cd/mlf/26.mlf"
		    "/cd/mlf/27.mlf"
		    "/cd/mlf/28.mlf"
		    "/cd/mlf/29.mlf"
		    ""))
	     (int (c:aref aspects ()) = (c:clist 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0))
	     (int (c:aref pairs ()) = (c:clist 0 1130 5225 733 2057 275 4843 2695 688 983 644 607 838 1096 1550 658 972 2483 969 2923 1472 2111 474 1147 2337 1730 1396 1597 1922 820 0)))) ;;resources

    (c:decl ((struct jpeg_decompress_struct eng)
	     (struct jpeg_error_mgr err)
	     (uint8_t (c:attribute (aligned 32)) (c:aref yuv (* 320 8 2)))	     	     
	     (unsigned char (c:dref (c:dref ())) (c:aref yuv_pl 3))
	     (unsigned char (c:dref ()) (c:aref yuv_pl_y 8))
	     (unsigned char (c:dref ()) (c:aref yuv_pl_u 8))
	     (unsigned char (c:dref ()) (c:aref yuv_pl_v 8))
	     (unsigned char (c:attribute (aligned 32)) (c:aref yuv_pl_buf (+ (* 320 8) (* 160 8) (* 160 8))))
	     (int tx_i = 0))) ;;jpg

    (c:decl ((file_t bfh = -1)
	     (uint8_t (c:attribute (aligned 32)) (c:aref blk_set (* 6 2048))))) ;;reader

    (c:decl ((snd_stream_hnd_t ost_strm)
	     (uint8_t (c:attribute (aligned 32)) (c:aref ost_buf (* 2 2048 2)))
	     (int ost_i = 0)
	     (int ost_skp = 0)
	     (int ost_lst = 0))) ;;ost

    (c:decl ((sfxhnd_t drip = 0)
	     (snd_stream_hnd_t mnu_strm)
	     (uint8_t (c:attribute (aligned 32)) (c:aref mbf (* 2 2048 2)))
	     (uint8_t (c:attribute (aligned 32)) (c:aref msr 1874944))	     	     
	     (int msr_i = 242652))) ;;menu    

    (c:decl ((uint64 vsync = 0)
	     (pvr_poly_hdr_t hd)
	     (pvr_poly_cxt_t ctx)
	     (pvr_vertex_t (c:aref tv_v 4))
	     (pvr_vertex_t (c:aref fs_v 4))
	     (pvr_vertex_t (c:aref flr_v 4))
	     (pvr_vertex_t (c:aref cd_v 4))
	     (pvr_vertex_t (c:aref blr_v 4))
	     (pvr_vertex_t vrt)	     
	     (pvr_ptr_t tv_tx)
	     (pvr_ptr_t grd_tx)
	     (pvr_ptr_t lgo_tx)
	     (pvr_ptr_t (c:aref cd_tx 4))
	     (pvr_ptr_t (c:aref flr_tx 3))
	     (pvr_ptr_t blr_tx))) ;;gfx
    
    (c:decl ((gzFile gzf = NULL)
	     (uint8_t (c:attribute (aligned 32)) (c:aref fs_buf (* 1024 1024 2)))
	     (uint8_t (c:dref splash))
	     (maple_device_t (c:dref pd))
	     (uint32_t btns)
	     (int numb = 0)
	     (void (c:dref vmu_imgs))
	     (vmufb_t vmufb)
	     (maple_device_t (c:dref vmu)))) ;;io

    (c:decl ((float polarity = 1)
	     (float (c:aref offsets ()) = (c:clist -345 0 345))
	     (float (c:aref deltas ()) = (c:clist -2.555555555555556 0 2.555555555555556))
	     (int (c:aref textures ()) = (c:clist 0 1 2))
	     (int (c:aref para_offsets ()) = (c:clist 29 149 269))
	     (float offset)
	     (float delta)
	     (int texture)
	     (int para_offset = 0)
	     (float (c:aref anim_offsets ()) =
		    (c:clist
		     0.0 0.24448499666913454 0.9772469673884412 2.1962086581713343
		     3.8979152708839306 6.077542917582 8.728911937378372 11.844509065495233
		     15.415501739083675 19.43176572744072 23.88192207131289 28.753348504296948
		     34.03224017142066 39.70363864454735 45.75145776919719 52.15856495768309
		     58.906787317288966 65.97700176868159 73.34916703398154 81.00239961491548
		     88.91497869892966 97.06448845173256 105.42782821765671 113.98129121702787
		     122.70063174556373 131.56114959060244 140.53769751596568 149.60484600092312
		     158.73689324482777 167.90795348457016 177.09204651542984 186.26309065604465
		     195.39515399907688 204.46231835498776 213.4388504093975 222.29936825443625
		     231.01869359008361 239.57217178234328 247.93552607271167 256.0850213010703
		     263.9976140765173 271.6508197499247 279.02299823131835 286.0932248371917
		     292.8414350423169 299.24854770837953 305.2963562014342 310.96775982857935
		     316.2466425676411 321.11807792868706 325.56823799602284 329.58449492410057
		     333.15549240485905 336.2710829900888 338.922457082418 341.10208728958526
		     342.8037900573418 344.02275367637594 344.7555143049291 345.0))
	     (float (c:aref anim_deltas ()) =
		    (c:clist
		     0.0 0.0018109999753269227 0.007238866425099566 0.016268212282750626
		     0.02887344645099208 0.045018836426533336 0.0646586069435435 0.08773710418885358
		     0.1141889017709902 0.1439390053884498 0.17690312645416956 0.21298776669849595
		     0.25209066793644935 0.29410102699664703 0.33889968717923846 0.3863597404272822
		     0.436346572720659 0.4887185316198637 0.5433271632146782 0.6000177749252998
		     0.6586294718439235 0.7189962107535746 0.780946875686346 0.8443058608668732
		     0.9088935684856573 0.9745270340044627 1.0410199815997458 1.1081840444512825
		     1.1758288388505762 1.2437626184042234 1.3117929371513322 1.3797265974521826
		     1.4473715111042733 1.5145356915184278 1.5810285215510929 1.6466619870698982
		     1.7112495821487677 1.7746086798692096 1.836559452390457 1.896926083711632
		     1.955537882048277 2.0122282944438874 2.0668370239356917 2.119209072868087
		     2.1691958151282735 2.2166559089509597 2.2614544903809946 2.303464887619106
		     2.3425677227232677 2.3786524291013857 2.4116165777483176 2.441366629067412
		     2.4678184622582156 2.4908969110376953 2.5105367191290227 2.5266821280710023
		     2.539287333758088 2.548316693899081 2.5537445504068823 2.555555555555556))
	     (float (c:aref anim_para_offsets ()) =
		    (c:clist
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
		     -64.0 -58.666626 -53.333374 -48.0 -42.666626 -37.333374 -32.0 -26.666626 -21.333374 -16.0 -10.666626 -5.333374)))) ;;anim

    (c:decl ((uint64_t mark))) ;;debug

    )

  (c:function ost_poll ((snd_stream_hnd_t (c:attribute (unused)) ign) (int req) (int (c:dref n))) -> (void (c:dref ()))
    (memmove ost_buf (c:+ ost_buf ost_lst) (c:- (* 2 2048 2) ost_lst))
    (c:-= ost_i ost_lst)
    (c:if (c:> req ost_i)
	  (c:= ost_skp 1)
	  (c:= ost_skp 0))
    (c:= ost_lst 0)
    (c:while (c:&& (c:>= req 2048) (c:<= (c:+ ost_lst 2048) ost_i))
      (c:-= req 2048)
      (c:+= ost_lst 2048))
    (c:= (c:dref n) ost_lst)
    (c:if (c:== 0 ost_lst)
	  (c:return (c:cast void (c:dref ()) NULL))
	  (c:return (c:cast void (c:dref ()) ost_buf))))

  (c:function mnu_poll ((snd_stream_hnd_t (c:attribute (unused)) ign) (int req) (int (c:dref n))) -> (void (c:dref ()))
    (c:for ((int i = 0) (c:< i req) (c:postfix++ i))
      (c:= (c:dref (c:+ mbf i))
	   (c:dref (c:+ msr (c:postfix++ msr_i))))
      (c:when (c:> msr_i 1874943)
	(c:= msr_i 0)))
    (c:= (c:dref n) req)
    (c:return (c:cast void (c:dref ()) mbf)))

  (c:function fetch ((void (c:attribute (unused)) (c:dref ign))) -> (void (c:dref ()))
    (gzread gzf fs_buf (/ cd_sz 3))
    (gzclose gzf)
    ;;(printf "fetched disc art\\n")    
    (c:= gzf (gzopen (c:aref titles cur) "r"))
    (c:when (c:== NULL gzf)
      (c:return NULL))
    (gzread gzf (c:+ fs_buf (/ cd_sz 3)) blr_sz)
    (gzclose gzf)
    ;;(printf "fetched title\\n")
    (c:return NULL))

  (c:function buttons () -> void
    (c:when (c:> (c:postfix-- numb) 0)
      (c:= btns 0)
      (c:return))
    (c:= pd (maple_enum_type 0 MAPLE_FUNC_CONTROLLER))
    (c:when pd
      (c:= btns (c:pref (c:cast cont_state_t (c:dref ()) (maple_dev_status pd)) buttons))))

  (c:function vmu_img ((int qid)) -> void    
    (vmufb_clear (c:addr-of vmufb))
    (vmufb_paint_area (c:addr-of vmufb) 0 0 48 32 (c:+ vmu_imgs (c:* 192 qid)))
    (c:= vmu (maple_enum_type 0 MAPLE_FUNC_LCD))
    (c:when (c:!= NULL vmu)
      ;;(printf "vmu!\\n")
      (vmufb_present (c:addr-of vmufb) vmu)))

  (c:function show_blank () -> void
    (pvr_wait_ready)
    (pvr_scene_begin)
    (pvr_scene_finish))

  (c:function draw_dynamic ((pvr_list_t typ) (int twd) (pvr_ptr_t tx) (int span) (pvr_vertex_t (c:aref lst ()))) -> void        
    (pvr_poly_cxt_txr (c:addr-of ctx) typ (c:\| PVR_TXRFMT_ARGB1555 PVR_TXRFMT_NOSTRIDE twd PVR_TXRFMT_VQ_DISABLE) span span tx PVR_FILTER_NONE)	
    (pvr_poly_compile (c:addr-of hd) (c:addr-of ctx))    
    (pvr_prim (c:addr-of hd) (sizeof hd))
    (c:for ((int i = 0) (c:< i 4) (c:postfix++ i))
      (c:= vrt (c:aref lst i))
      (mat_trans_single3_nodiv (c:oref vrt x)
			       (c:oref vrt y)
			       (c:oref vrt z))
      (pvr_prim (c:addr-of vrt) (sizeof pvr_vertex_t))))

  (c:function draw_static ((pvr_list_t typ) (int twd) (pvr_ptr_t tx) (int span) (pvr_vertex_t (c:aref lst ()))) -> void        
    (pvr_poly_cxt_txr (c:addr-of ctx) typ (c:\| PVR_TXRFMT_ARGB1555 PVR_TXRFMT_NOSTRIDE twd PVR_TXRFMT_VQ_DISABLE) span span tx PVR_FILTER_NONE)	
    (pvr_poly_compile (c:addr-of hd) (c:addr-of ctx))    
    (pvr_prim (c:addr-of hd) (sizeof hd))
    (c:for ((int i = 0) (c:< i 4) (c:postfix++ i))
      (pvr_prim (c:+ lst i) (sizeof pvr_vertex_t))))

  (c:function show_logo () -> void
    (pvr_wait_ready)
    (pvr_scene_begin)
    (pvr_list_begin PVR_LIST_OP_POLY)
    (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_TWIDDLED lgo_tx 1024 fs_v)
    (pvr_list_finish)
    (pvr_scene_finish))

  (c:function a43 () -> void  
    (c:= (c:oref (c:aref tv_v 0) x) 0)
    (c:= (c:oref (c:aref tv_v 0) y) 0)
    
    (c:= (c:oref (c:aref tv_v 1) x) 640)
    (c:= (c:oref (c:aref tv_v 1) y) 0)
    
    (c:= (c:oref (c:aref tv_v 2) x) 0)
    (c:= (c:oref (c:aref tv_v 2) y) 480)
    
    (c:= (c:oref (c:aref tv_v 3) x) 640)
    (c:= (c:oref (c:aref tv_v 3) y) 480))
  (c:function a169 () -> void  
    (c:= (c:oref (c:aref tv_v 0) x) 0)
    (c:= (c:oref (c:aref tv_v 0) y) 60)
    
    (c:= (c:oref (c:aref tv_v 1) x) 640)
    (c:= (c:oref (c:aref tv_v 1) y) 60)
    
    (c:= (c:oref (c:aref tv_v 2) x) 0)
    (c:= (c:oref (c:aref tv_v 2) y) 420)
    
    (c:= (c:oref (c:aref tv_v 3) x) 640)
    (c:= (c:oref (c:aref tv_v 3) y) 420))
  (c:function frame_x ((int adj)) -> void
    (pvr_wait_ready)
    (pvr_scene_begin)
    (pvr_list_begin PVR_LIST_OP_POLY)
    (pvr_poly_cxt_txr (c:addr-of ctx) PVR_LIST_OP_POLY (c:\| PVR_TXRFMT_YUV422 PVR_TXRFMT_VQ_DISABLE PVR_TXRFMT_NONTWIDDLED #x02000000) 512 512 (c:+ tv_tx (c:* adj (* 320 160 2))) PVR_FILTER_NONE)	
    (pvr_poly_compile (c:addr-of hd) (c:addr-of ctx))    
    (pvr_prim (c:addr-of hd) (sizeof hd))
    (c:for ((int i = 0) (c:< i 4) (c:postfix++ i))
      (pvr_prim (c:+ tv_v i) (sizeof pvr_vertex_t)))
    (pvr_list_finish)
    (pvr_scene_finish))

  (c:function main ((int argc (c:attribute unused)) (char (c:dref (c:aref argv ())) (c:attribute unused))) -> int        
    (c:decl (;;states
	     (int state = st-init)	     	     
	     (int sub-timer = 0)
	     (int pairs-togo = 947)
	     (int next = 1))

      (c:while 1
	(c:switch state
		  
		  (st-init
		   (c:if (c:== (vid_check_cable) CT_VGA)
			 (vid_set_mode DM_640x480_VGA PM_RGB565)	    
			 (vid_set_mode DM_640x480_NTSC_IL PM_RGB565))

		   (c:decl ((static pvr_init_params_t cfg =
				    (c:clist
				     (c:clist
				      PVR_BINSIZE_8
				      PVR_BINSIZE_0
				      PVR_BINSIZE_0
				      PVR_BINSIZE_0
				      PVR_BINSIZE_8)
				     (* 512 1024) 0 0 1 0)))
		     (pvr_init (c:addr-of cfg)))
		   (PVR_SET PVR_TEXTURE_MODULO 10)

		   (c:progn ;; vram
		     (c:= tv_tx (pvr_mem_malloc (+ tv_sz grd_sz lgo_sz cd_sz flr_sz blr_sz)))
		     (c:= grd_tx (c:+ tv_tx tv_sz))
		     (c:= lgo_tx (c:+ grd_tx grd_sz))
		     (c:= (c:aref cd_tx 0) (c:+ lgo_tx lgo_sz))
		     (c:= (c:aref cd_tx 1) (c:+ (c:aref cd_tx 0) (/ cd_sz 3)))
		     (c:= (c:aref cd_tx 2) (c:+ (c:aref cd_tx 1) (/ cd_sz 3)))
		     (c:= (c:aref flr_tx 0) (c:+ (c:aref cd_tx 2) (/ cd_sz 3)))
		     (c:= (c:aref flr_tx 1) (c:+ (c:aref flr_tx 0) (/ flr_sz 3)))
		     (c:= (c:aref flr_tx 2) (c:+ (c:aref flr_tx 1) (/ flr_sz 3)))
		     (c:= blr_tx (c:+ (c:aref flr_tx 2) (/ flr_sz 3))))

		   (c:progn   ;; geo
		     (c:progn ;;tv 
		       (c:= (c:oref (c:aref tv_v 0) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref tv_v 0) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref tv_v 0) x) 0)
		       (c:= (c:oref (c:aref tv_v 0) y) 0)
		       (c:= (c:oref (c:aref tv_v 0) z) 1)
		       (c:= (c:oref (c:aref tv_v 0) u) 0)
		       (c:= (c:oref (c:aref tv_v 0) v) 0)

		       (c:= (c:oref (c:aref tv_v 1) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref tv_v 1) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref tv_v 1) x) 640)
		       (c:= (c:oref (c:aref tv_v 1) y) 0)
		       (c:= (c:oref (c:aref tv_v 1) z) 1)
		       (c:= (c:oref (c:aref tv_v 1) u) (/ 320 512.0))
		       (c:= (c:oref (c:aref tv_v 1) v) 0)

		       (c:= (c:oref (c:aref tv_v 2) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref tv_v 2) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref tv_v 2) x) 0)
		       (c:= (c:oref (c:aref tv_v 2) y) 480)
		       (c:= (c:oref (c:aref tv_v 2) z) 1)
		       (c:= (c:oref (c:aref tv_v 2) u) 0)
		       (c:= (c:oref (c:aref tv_v 2) v) (/ 160 512.0))

		       (c:= (c:oref (c:aref tv_v 3) flags) PVR_CMD_VERTEX_EOL)
		       (c:= (c:oref (c:aref tv_v 3) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref tv_v 3) x) 640)
		       (c:= (c:oref (c:aref tv_v 3) y) 480)
		       (c:= (c:oref (c:aref tv_v 3) z) 1)
		       (c:= (c:oref (c:aref tv_v 3) u) (/ 320 512.0))
		       (c:= (c:oref (c:aref tv_v 3) v) (/ 160 512.0)))
		     (c:progn ;;fs
		       (c:= (c:oref (c:aref fs_v 0) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref fs_v 0) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref fs_v 0) x) 0)
		       (c:= (c:oref (c:aref fs_v 0) y) 0)
		       (c:= (c:oref (c:aref fs_v 0) z) 1)
		       (c:= (c:oref (c:aref fs_v 0) u) 0)
		       (c:= (c:oref (c:aref fs_v 0) v) 0)

		       (c:= (c:oref (c:aref fs_v 1) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref fs_v 1) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref fs_v 1) x) 640)
		       (c:= (c:oref (c:aref fs_v 1) y) 0)
		       (c:= (c:oref (c:aref fs_v 1) z) 1)
		       (c:= (c:oref (c:aref fs_v 1) u) (/ 640 1024.0))
		       (c:= (c:oref (c:aref fs_v 1) v) 0)

		       (c:= (c:oref (c:aref fs_v 2) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref fs_v 2) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref fs_v 2) x) 0)
		       (c:= (c:oref (c:aref fs_v 2) y) 480)
		       (c:= (c:oref (c:aref fs_v 2) z) 1)
		       (c:= (c:oref (c:aref fs_v 2) u) 0)
		       (c:= (c:oref (c:aref fs_v 2) v) (/ 480 1024.0))

		       (c:= (c:oref (c:aref fs_v 3) flags) PVR_CMD_VERTEX_EOL)
		       (c:= (c:oref (c:aref fs_v 3) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref fs_v 3) x) 640)
		       (c:= (c:oref (c:aref fs_v 3) y) 480)
		       (c:= (c:oref (c:aref fs_v 3) z) 1)
		       (c:= (c:oref (c:aref fs_v 3) u) (/ 640 1024.0))
		       (c:= (c:oref (c:aref fs_v 3) v) (/ 480 1024.0)))
		     (c:progn ;;flr
		       (c:= (c:oref (c:aref flr_v 0) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref flr_v 0) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref flr_v 0) x) 220)
		       (c:= (c:oref (c:aref flr_v 0) y) 132)
		       (c:= (c:oref (c:aref flr_v 0) z) 3)
		       (c:= (c:oref (c:aref flr_v 0) u) 0)
		       (c:= (c:oref (c:aref flr_v 0) v) 0)

		       (c:= (c:oref (c:aref flr_v 1) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref flr_v 1) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref flr_v 1) x) 420)
		       (c:= (c:oref (c:aref flr_v 1) y) 132)
		       (c:= (c:oref (c:aref flr_v 1) z) 3)
		       (c:= (c:oref (c:aref flr_v 1) u) (/ 200 256.0))
		       (c:= (c:oref (c:aref flr_v 1) v) 0)

		       (c:= (c:oref (c:aref flr_v 2) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref flr_v 2) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref flr_v 2) x) 220)
		       (c:= (c:oref (c:aref flr_v 2) y) 332)
		       (c:= (c:oref (c:aref flr_v 2) z) 3)
		       (c:= (c:oref (c:aref flr_v 2) u) 0)
		       (c:= (c:oref (c:aref flr_v 2) v) (/ 200 256.0))

		       (c:= (c:oref (c:aref flr_v 3) flags) PVR_CMD_VERTEX_EOL)
		       (c:= (c:oref (c:aref flr_v 3) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref flr_v 3) x) 420)
		       (c:= (c:oref (c:aref flr_v 3) y) 332)
		       (c:= (c:oref (c:aref flr_v 3) z) 3)
		       (c:= (c:oref (c:aref flr_v 3) u) (/ 200 256.0))
		       (c:= (c:oref (c:aref flr_v 3) v) (/ 200 256.0)))
		     (c:progn ;;cd
		       (c:= (c:oref (c:aref cd_v 0) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref cd_v 0) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref cd_v 0) x) 185)
		       (c:= (c:oref (c:aref cd_v 0) y) 113)
		       (c:= (c:oref (c:aref cd_v 0) z) 4)
		       (c:= (c:oref (c:aref cd_v 0) u) 0)
		       (c:= (c:oref (c:aref cd_v 0) v) 0)

		       (c:= (c:oref (c:aref cd_v 1) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref cd_v 1) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref cd_v 1) x) 455)
		       (c:= (c:oref (c:aref cd_v 1) y) 113)
		       (c:= (c:oref (c:aref cd_v 1) z) 4)
		       (c:= (c:oref (c:aref cd_v 1) u) (/ 270 512.0))
		       (c:= (c:oref (c:aref cd_v 1) v) 0)

		       (c:= (c:oref (c:aref cd_v 2) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref cd_v 2) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref cd_v 2) x) 185)
		       (c:= (c:oref (c:aref cd_v 2) y) 383)
		       (c:= (c:oref (c:aref cd_v 2) z) 4)
		       (c:= (c:oref (c:aref cd_v 2) u) 0)
		       (c:= (c:oref (c:aref cd_v 2) v) (/ 270 512.0))

		       (c:= (c:oref (c:aref cd_v 3) flags) PVR_CMD_VERTEX_EOL)
		       (c:= (c:oref (c:aref cd_v 3) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref cd_v 3) x) 455)
		       (c:= (c:oref (c:aref cd_v 3) y) 383)
		       (c:= (c:oref (c:aref cd_v 3) z) 4)
		       (c:= (c:oref (c:aref cd_v 3) u) (/ 270 512.0))
		       (c:= (c:oref (c:aref cd_v 3) v) (/ 270 512.0)))
		     (c:progn ;;blr
		       (c:= (c:oref (c:aref blr_v 0) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref blr_v 0) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref blr_v 0) x) 0)
		       (c:= (c:oref (c:aref blr_v 0) y) 382)
		       (c:= (c:oref (c:aref blr_v 0) z) 2)
		       (c:= (c:oref (c:aref blr_v 0) u) 0)
		       (c:= (c:oref (c:aref blr_v 0) v) 0)

		       (c:= (c:oref (c:aref blr_v 1) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref blr_v 1) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref blr_v 1) x) 640)
		       (c:= (c:oref (c:aref blr_v 1) y) 382)
		       (c:= (c:oref (c:aref blr_v 1) z) 2)
		       (c:= (c:oref (c:aref blr_v 1) u) (/ 640 1024.0))
		       (c:= (c:oref (c:aref blr_v 1) v) 0)

		       (c:= (c:oref (c:aref blr_v 2) flags) PVR_CMD_VERTEX)
		       (c:= (c:oref (c:aref blr_v 2) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref blr_v 2) x) 0)
		       (c:= (c:oref (c:aref blr_v 2) y) 480)
		       (c:= (c:oref (c:aref blr_v 2) z) 2)
		       (c:= (c:oref (c:aref blr_v 2) u) 0)
		       (c:= (c:oref (c:aref blr_v 2) v) (/ 98 1024.0))

		       (c:= (c:oref (c:aref blr_v 3) flags) PVR_CMD_VERTEX_EOL)
		       (c:= (c:oref (c:aref blr_v 3) argb) (PVR_PACK_COLOR 1.0 1.0 1.0 1.0))
		       (c:= (c:oref (c:aref blr_v 3) x) 640)
		       (c:= (c:oref (c:aref blr_v 3) y) 480)
		       (c:= (c:oref (c:aref blr_v 3) z) 2)
		       (c:= (c:oref (c:aref blr_v 3) u) (/ 640 1024.0))
		       (c:= (c:oref (c:aref blr_v 3) v) (/ 98 1024.0)))
		     )

		   (c:progn ;; jpeg eng
		     (c:for ((int i = 0) (c:< i 8) (c:postfix++ i))
		       (c:= (c:aref yuv_pl_y i) (c:+ yuv_pl_buf (c:* i 320)))
		       (c:= (c:aref yuv_pl_u i) (c:+ yuv_pl_buf (c:* i 160) (* 320 8)))
		       (c:= (c:aref yuv_pl_v i) (c:+ yuv_pl_buf (c:* i 160) (* 320 8) (* 160 8))))
		     
		     (c:= (c:aref yuv_pl 0) yuv_pl_y)
		     (c:= (c:aref yuv_pl 1) yuv_pl_u)
		     (c:= (c:aref yuv_pl 2) yuv_pl_v)
		     
		     (c:= (c:oref eng err) (jpeg_std_error (c:addr-of err)))
		     (jpeg_create_decompress (c:addr-of eng)))

		   (c:= vmu_imgs (fs_mmap (fs_open "/rd/vmu.bin" O_RDONLY)))
		   		  
		   (snd_stream_init)
		   (c:= ost_strm (snd_stream_alloc ost_poll (* 2 2048)))
		   (c:= mnu_strm (snd_stream_alloc mnu_poll (* 2 2048)))
		   (c:= drip (snd_sfx_load "/rd/drip.wav"))

		   (vmu_img 0)
		   
		   (pvr_set_bg_color 0.0 0.0 0.0)
		   
		   (c:= splash (fs_mmap (fs_open "/rd/splash.tex" O_RDONLY)))
		   (c:for ((int i = 0) (c:< i 480) (c:postfix++ i))		     
		     (pvr_txr_load (c:+ splash (c:* i (* 640 2))) (c:+ lgo_tx (c:* i (* 1024 2))) (* 640 2)))
		   		   
		   (c:= state st-stall)
		   (c:break))

		  (st-stall
		   ;;(show_logo)
		   ;;(c:break)
		   (pvr_wait_ready)
		   (pvr_scene_begin)
		   (pvr_list_begin PVR_LIST_OP_POLY)
		   (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_NONTWIDDLED lgo_tx 1024 fs_v)		  
		   (pvr_list_finish)
		   (pvr_scene_finish)
		   (buttons)
		   (c:when (c:& btns CONT_A)
		     (snd_sfx_play drip 255 128)
		     ;;(pvr_set_bg_color 0.214 0.214 0.214)
		     (vmu_img 1)
		     ;;(pvr_set_bg_color 0.0 0.0 0.0)
		     (c:= state st-boot))		   		   

		   (c:break))

		  (st-boot
		   ;; cat ng.crp flr00.crp flr01.crp flr02.crp grd.crp menu.adpcm cvr.crp lgo.crp 00.crp 01.crp 02.crp 01.tex > 000.bin
		   (show_blank)
		   (c:= mark (timer_ms_gettime64))
		   ;;(c:= mark 3600000.0)
		   (c:= gzf (gzopen "/cd/cds/000.bin.gz" "r"))		   
		   (gzread gzf fs_buf lgo_sz)		     
		   (pvr_txr_load fs_buf lgo_tx lgo_sz)
		   (gzread gzf fs_buf flr_sz)
		   (pvr_txr_load fs_buf (c:aref flr_tx 0) flr_sz)
		   ;;(printf "ng flr: %llu\\n" (c:- (timer_ms_gettime64) mark))
		   (c:while (c:< (c:- (timer_ms_gettime64) mark) 1250)
		     (thd_pass))
		   (show_logo)
		   (c:= mark (timer_ms_gettime64))
		   ;;(c:= mark 3600000.0)
		   (gzread gzf fs_buf (* 607 1024 2))
		   (pvr_txr_load fs_buf grd_tx grd_sz)
		   (gzread gzf msr 1874944)
		   ;;(printf "grd music: %llu\\n" (c:- (timer_ms_gettime64) mark))
		   (c:while (c:< (c:- (timer_ms_gettime64) mark) 4000)
		     (thd_pass))
		   (show_blank)
		   (c:= mark (timer_ms_gettime64))
		   ;;(c:= mark 3600000.0)
		   (gzread gzf fs_buf lgo_sz)
		   (pvr_txr_load fs_buf lgo_tx lgo_sz)
		   ;;(printf "cvr: %llu\\n" (c:- (timer_ms_gettime64) mark))
		   (c:while (c:< (c:- (timer_ms_gettime64) mark) 1250)
		     (thd_pass))
		   (show_logo)
		   (c:= mark (timer_ms_gettime64))
		   ;;(c:= mark 3600000.0)
		   (gzread gzf fs_buf lgo_sz)
		   (pvr_txr_load fs_buf lgo_tx lgo_sz)		   
		   (gzread gzf fs_buf (* 2 (/ cd_sz 3)))
		   (pvr_txr_load fs_buf (c:aref cd_tx 0) (* 2 (/ cd_sz 3)))
		   (gzread gzf fs_buf (/ cd_sz 3))
		   (pvr_txr_load fs_buf (c:aref cd_tx 2) (/ cd_sz 3))
		   ;;(printf "logo cds: %llu\\n" (c:- (timer_ms_gettime64) mark))
		   (c:while (c:< (c:- (timer_ms_gettime64) mark) 4000)
		     (thd_pass))
		   (show_blank)
		   (c:= mark (timer_ms_gettime64))
		   ;;(c:= mark 3600000.0)
		   (gzread gzf fs_buf blr_sz)
		   (c:for ((int i = 0) (c:< i 98) (c:postfix++ i))
		     (pvr_txr_load (c:+ fs_buf (c:* i (* 640 2))) (c:+ blr_tx (c:* i (* 1024 2))) (* 640 2)))		   
		   (gzclose gzf)
		   ;;(printf "blrb and close: %llu\\n" (c:- (timer_ms_gettime64) mark))
		   (c:while (c:< (c:- (timer_ms_gettime64) mark) 1250)
		     (thd_pass))

		   (c:= state st-menu-init)
		   (c:break))

		  (st-menu-init
		   (c:= sub-timer 0)
		   (c:= polarity -1)
		   (c:= (c:aref offsets 0) -345)
		   (c:= (c:aref offsets 1) 0)
		   (c:= (c:aref offsets 2) 345)
		   (c:= (c:aref deltas 0) 2.555555555555556)
		   (c:= (c:aref deltas 1) 0)
		   (c:= (c:aref deltas 2) -2.555555555555556)

		   (snd_stream_start_adpcm mnu_strm 22050 1)
		   (snd_stream_volume mnu_strm 192)
		   
		   (c:= state st-menu-still)
		   (c:break))

		  (st-menu-still
		   (c:for ((int f = 0) (c:< f 2) (c:postfix++ f))
		     (pvr_wait_ready)
		     (pvr_scene_begin)
		     (pvr_list_begin PVR_LIST_OP_POLY)
		     (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_TWIDDLED grd_tx 1024 fs_v)
		     (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_NONTWIDDLED blr_tx 1024 blr_v)		     
		     (pvr_list_finish)
		     
		     (pvr_list_begin PVR_LIST_PT_POLY)

		     (c:for ((int i = 0) (c:< i 3) (c:postfix++ i))
		       (mat_identity)
		       (mat_translate (c:aref anim_para_offsets (c:% (c:+ para_offset (c:aref para_offsets i)) 360)) 0 0)
		       (draw_dynamic PVR_LIST_PT_POLY PVR_TXRFMT_TWIDDLED (c:aref flr_tx i) 256 flr_v))
		     
		     (c:for ((int i = 0) (c:< i 3) (c:postfix++ i))		       		       		       
		       (mat_identity)
		       (mat_translate 320 248 0)		     		     
		       (mat_translate (c:aref offsets i) 0 0)
		       (mat_rotate_z (c:aref deltas i))
		       (mat_translate -320 -248 0)		     
		       (draw_dynamic PVR_LIST_PT_POLY PVR_TXRFMT_TWIDDLED (c:aref cd_tx (c:aref textures i)) 512 cd_v))
		     		     
		     (pvr_list_finish)
		     
		     (snd_stream_poll mnu_strm)

		     (c:when (c:== 1 f)
		       (buttons)
		       (c:when (c:&& (c:!= top cur) (c:& btns CONT_DPAD_RIGHT))
			 (c:= polarity -1)
			 (c:= state st-menu-prime))
		       (c:when (c:&& (c:!= 1 cur) (c:& btns CONT_DPAD_LEFT))
			 (c:= polarity 1)
			 (c:= state st-menu-prime))		     
		       (c:when (c:\|\| (c:& btns CONT_A) (c:& btns CONT_START))
			 (c:= state st-spool)))		     
		     
		     (pvr_scene_finish))		   
		  		   
		   (c:break))

		  (st-menu-prime
		   (c:= cur (c:- cur polarity))
		   (c:= next (c:- cur polarity))
		   
		   (c:= gzf (gzopen (c:aref covers next) "r"))
		   (c:when (c:== NULL gzf)
		     (c:= numb 15)
		     (c:= cur (c:+ cur polarity))
		     (c:= next (c:+ cur polarity))
		     (c:= state st-menu-init)
		     (c:break))
		   
		   (thd_create 1 fetch NULL)
		   (snd_sfx_play drip 255 128)
		   
		   (c:= sub-timer 0)
		   (c:= state st-menu-move)
		   (c:break))

		  (st-menu-move
		   (c:for ((int f = 0) (c:< f 2) (c:postfix++ f))
		     (pvr_wait_ready)
		     (pvr_scene_begin)
		     (pvr_list_begin PVR_LIST_OP_POLY)
		     (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_TWIDDLED grd_tx 1024 fs_v)
		     ;; (c:when (c:< sub-timer 8)
		     ;;   (draw_static PVR_LIST_OP_POLY PVR_TXRFMT_NONTWIDDLED blr_tx 1024 blr_v))
		     (pvr_list_finish)
		     
		     (pvr_list_begin PVR_LIST_PT_POLY)

		     (c:for ((int i = 0) (c:< i 3) (c:postfix++ i))
		       (mat_identity)
		       (mat_translate (c:aref anim_para_offsets (c:% (c:+ para_offset (c:aref para_offsets i)) 360)) 0 0)
		       (draw_dynamic PVR_LIST_PT_POLY PVR_TXRFMT_TWIDDLED (c:aref flr_tx i) 256 flr_v))
		     
		     (c:for ((int i = 0) (c:< i 3) (c:postfix++ i))
		       (c:= offset (c:+ (c:aref offsets i) (c:* polarity (c:aref anim_offsets sub-timer))))
		       (c:when (c:> (c:- (c:* polarity offset) 455) 0)
			 ;;(printf "need new texture at frame: %d\\n" sub-timer)
			 (pvr_txr_load fs_buf (c:aref cd_tx (c:aref textures i)) (/ cd_sz 3))			 
			 (c:= (c:aref offsets i) (c:* -2 (c:aref offsets i)) )
			 (c:= (c:aref deltas i) (c:* -2 (c:aref deltas i)) )
			 (c:= offset (c:+ (c:aref offsets i) (c:* polarity (c:aref anim_offsets sub-timer)))))
		       
		       (mat_identity)
		       (mat_translate 320 248 0)		     		     
		       (mat_translate offset 0 0)
		       (mat_rotate_z (c:+ (c:aref deltas i) (c:* -1 polarity (c:aref anim_deltas sub-timer))))
		       (mat_translate -320 -248 0)		     
		       (draw_dynamic PVR_LIST_PT_POLY PVR_TXRFMT_TWIDDLED (c:aref cd_tx (c:aref textures i)) 512 cd_v))
		     
		     (pvr_list_finish)

		     (snd_stream_poll mnu_strm)
		     
		     (pvr_scene_finish))		   
		   (c:= para_offset (c:+ para_offset polarity))
		   (c:when (c:< para_offset 0) (c:= para_offset 359))
		   (c:when (c:> para_offset 359) (c:= para_offset 0))
		   (c:when (c:> (c:postfix++ sub-timer) 58)
		     (c:if (c:> polarity 0)
			   (c:progn
			     (c:= texture (c:aref textures 2))
			     (c:= (c:aref textures 2) (c:aref textures 1))
			     (c:= (c:aref textures 1) (c:aref textures 0))
			     (c:= (c:aref textures 0) texture))
			   (c:progn
			     (c:= texture (c:aref textures 0))
			     (c:= (c:aref textures 0) (c:aref textures 1))
			     (c:= (c:aref textures 1) (c:aref textures 2))
			     (c:= (c:aref textures 2) texture)))
		     (c:for ((int i = 0) (c:< i 98) (c:postfix++ i))
		       (pvr_txr_load (c:+ fs_buf (/ cd_sz 3) (c:* i (* 640 2))) (c:+ blr_tx (c:* i (* 1024 2))) (* 640 2)))
		     (c:= (c:aref offsets 0) -345)
		     (c:= (c:aref offsets 1) 0)
		     (c:= (c:aref offsets 2) 345)
		     (c:= (c:aref deltas 0) 2.555555555555556)
		     (c:= (c:aref deltas 1) 0)
		     (c:= (c:aref deltas 2) -2.555555555555556)
		     (c:= state st-menu-still))		   
		   (c:break))

		  (st-spool
		   (c:= numb 7)
		   (snd_stream_stop mnu_strm)
		   (snd_sfx_play drip 255 128)
		   (show_logo)

		   (c:= bfh (fs_open (c:aref videos cur) O_RDONLY))
		   (c:when (c:== -1 bfh)
		     (c:= state st-menu-init)
		     (c:break))
		   
		   (snd_stream_start_adpcm ost_strm 22050 1)
		   (snd_stream_volume ost_strm 255)
		   (c:= pairs-togo (c:aref pairs cur))
		   (c:if (c:aref aspects cur)
			 (a43)
			 (a169))
		   
		   (c:= state st-project)
		   
		   (c:break))

		  (st-project
		   (c:when (c:< (c:postfix-- pairs-togo) 1)
		     ;;(fs_close bfh)
		     ;;(snd_stream_stop ost_strm)
		     (c:= state st-unspool)
		     (c:break))

		   (c:when (c:<= (c:+ ost_i 1470) (* 2 2048 2))
		     (memcpy (c:+ ost_buf ost_i) blk_set 1470)
		     (c:+= ost_i 1470))

		   (c:= ost_skp 0)
		   (snd_stream_poll ost_strm)		   
		   (c:when (c:== ost_skp 1)
		     (fs_read bfh blk_set (* 6 2048)) 1		     
		     (c:break))
		   
		   (frame_b)
		   ;;(printf "...: %llu\\n" (c:- (timer_ms_gettime64) vsync))
		   (c:= vsync (timer_ms_gettime64))

		   (fs_read bfh blk_set (* 6 2048)) 1		   

		   (jpeg_mem_src (c:addr-of eng) (c:+ blk_set 1470) 10818)
		   (jpeg_read_header (c:addr-of eng) false)		   
		   (c:= (c:oref eng out_color_space) JCS_YCbCr)
		   (c:= (c:oref eng raw_data_out) true)
		   (jpeg_start_decompress (c:addr-of eng))

		   (c:= tx_i 0)		   
		   (c:for ((int i = 0) (c:< i 10) (c:postfix++ i))
		     (jpeg_read_raw_data (c:addr-of eng) yuv_pl 8)
		     (c:for ((int i = 0) (c:< i (* 160 8)) (c:postfix++ i))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 0))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) 0) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 1))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 0)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 2))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) (* 160 8)) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 3))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 1))))
		     (pvr_txr_load yuv (c:+ tv_tx (c:* (c:postfix++ tx_i) (* 320 8 2))) (* 320 8 2)))
		   
		   (frame_b)
		   ;;(printf "...: %llu\\n" (c:- (timer_ms_gettime64) vsync))
		   (c:= vsync (timer_ms_gettime64))
		   
		   (c:for ((int i = 0) (c:< i 10) (c:postfix++ i))
		     (jpeg_read_raw_data (c:addr-of eng) yuv_pl 8)
		     (c:for ((int i = 0) (c:< i (* 160 8)) (c:postfix++ i))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 0))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) 0) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 1))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 0)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 2))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) (* 160 8)) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 3))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 1))))
		     (pvr_txr_load yuv (c:+ tv_tx (c:* (c:postfix++ tx_i) (* 320 8 2))) (* 320 8 2)))
		   
		   (frame_a)
		   ;;(printf "...: %llu\\n" (c:- (timer_ms_gettime64) vsync))
		   (c:= vsync (timer_ms_gettime64))

		   (c:for ((int i = 0) (c:< i 10) (c:postfix++ i))
		     (jpeg_read_raw_data (c:addr-of eng) yuv_pl 8)
		     (c:for ((int i = 0) (c:< i (* 160 8)) (c:postfix++ i))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 0))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) 0) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 1))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 0)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 2))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) (* 160 8)) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 3))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 1))))
		     (pvr_txr_load yuv (c:+ tv_tx (c:* (c:postfix++ tx_i) (* 320 8 2))) (* 320 8 2)))
		   
		   (frame_a)
		   ;;(print f"...: %llu\\n" (c:- (timer_ms_gettime64) vsync))
		   (c:= vsync (timer_ms_gettime64))

		   (c:for ((int i = 0) (c:< i 10) (c:postfix++ i))
		     (jpeg_read_raw_data (c:addr-of eng) yuv_pl 8)
		     (c:for ((int i = 0) (c:< i (* 160 8)) (c:postfix++ i))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 0))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) 0) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 1))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 0)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 2))
			    (c:dref (c:+ yuv_pl_buf (+ (* 320 8) (* 160 8)) i)))
		       (c:= (c:dref (c:+ yuv (c:* i 4) 3))
			    (c:dref (c:+ yuv_pl_buf (c:* i 2) 1))))
		     (pvr_txr_load yuv (c:+ tv_tx (c:* (c:postfix++ tx_i) (* 320 8 2))) (* 320 8 2)))

		   (jpeg_finish_decompress (c:addr-of eng))

		   (buttons)		   
		   (c:when btns		     
		     (c:= state st-unspool))
		   
		   (c:break))

		  (st-unspool
		   (c:= numb 15)
		   (c:when (c:!= -1 bfh)
		     (fs_close bfh))		   
		   (snd_stream_stop ost_strm)
		   (show_logo)
		   (c:= state st-menu-init)
		   (c:break))
		  
		  ))
      (c:return 0)))
  
  )
(compile-c c-src)
