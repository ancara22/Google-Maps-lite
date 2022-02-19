#lang racket/gui

(require "main_v3.rkt")               ;Require functions
(require 2htdp/image)



(define emptyLine " - - -                                       ")     ;Empty line for choice%

(define-values (mainFrameWidth mainFrameHeight) (values 400 400))      ;Main frame size
(define-values (imagePaneHeight imageCanvas) (values 300 0))           ;Panel/canvas size



(define mainFrame (new frame%                                     ;Main frame/window
                       [label "Maps Lite"]                        ;Frame label
                       [width mainFrameWidth]                     ;Frame width
                       [height mainFrameHeight]                   ;Frame hight
                       [stretchable-width #f]	                  ;Fixed size/Cannot be changed by user
                       [stretchable-height #f]))



(define panel_image (new vertical-panel%                          ;Panel for Image/Tube map
                     [parent mainFrame]                           ;Parent is the main frame
                     [min-height imagePaneHeight]))               ;Minimal height


(define image_canvas (new canvas% 
                          [parent panel_image]                    ;Image container
                          [min-width mainFrameWidth]              ;Minimal container width
                          [min-height imagePaneHeight]            ;Minimal container height
                          [paint-callback                         ;Image painting
                           (λ (canvas dc)
                             (send dc draw-bitmap (read-bitmap "metro.png") 0 0))]))




(define v_panel (new vertical-panel%                              ;Vertical panel for Choices
                     [parent mainFrame]                           ;Parent is main frame 
                     [style (list 'border )]                      ;Adding border to panel
                     [min-width 350]                              ;Minimal width
                     [min-height 150]                             ;Minimal height
                     [alignment (list 'center 'top)]))            ;Align to top and center



(define h_panel (new horizontal-panel%                            ;Horizontal panel for buttons
                     [parent mainFrame]                           ;Parent is main frame 
                     [alignment (list 'center 'center)]))         ;Align to center



(define start (new choice%                                        ;Choice line for Start Station
                   [label "Start:   "]                            ;Label for choice line 
                   [parent v_panel]                               ;Parent is vertical panel
                   [choices (cons emptyLine (flatten station_names_list))]    ;Options for choice
                   [vert-margin 20]))                             ;Vertical distance from other items


(define finish (new choice%                                       ;Choice line for Finish Station
                   [label "Finish: "]                             ;Label for choice line 
                   [parent v_panel]                               ;Parent is vertical panel
                   [choices (cons emptyLine (flatten station_names_list))]    ;Options for choice
                   [vert-margin 10]))                             ;Vertical distance from other items


(define resultFrame (new frame%                                   ;The second frame for results 
                       [label "Path"]                             ;Label for frame
                       [width 300]                                ;Frame Width 
                       [height 120]                               ;Frame Height
                       [min-width 300]	                          ;Minimal width
                       [min-height 120]                           ;Minimal height
                       [alignment (list 'center 'top)]))          ;Align to top and center


(define btn_find (new button%                                     ;Main button, for finding the path
                      [label "Find Path"]                         ;Button label
                      [parent h_panel]                            ;Parent is horizontal panel
                      [callback (lambda (button event)            ;Actions in case of button pressing
                                   (cond
                                     ((and (not(equal? (send start get-string-selection) emptyLine)) (not(equal? (send finish get-string-selection) emptyLine)))

                                      ;FUNCTIONS CALLINGS_____________________________________________________________________________________________________________________________

                                      (define finalPath (main                                          ;Finding the final path
                                                         (send start get-string-selection)
                                                         (send finish get-string-selection)
                                                         data_base_list '()))                                   
                                       

                                      (define distance (path_distance                                  ;Finding the final distance
                                                        (create_pairs (main
                                                                       (send start get-string-selection)
                                                                       (send finish get-string-selection)
                                                                       data_base_list '()))))

                                      
                                      ;CALCULATIONS__________________________________________________________________________________________________________________________________
                                      
                                      (define time (/ distance 20.0))                                   ;Calculate the time required to get from Start to Finish
                                      (define h (inexact->exact (truncate (/ distance 20.0))))          ;Calculating the number of hours
                                      (define m (inexact->exact (truncate(* 60 (- time  h )))))         ;Calculating the number of minuts


                                      ;SEND MESSAGES_________________________________________________________________________________________________________________________________
                                      
                                      (send msg set-label "Done!")                                                                                          ;Send "Done!" message to user
                                      (send pathMessage set-label (string-join (map ~a (remove-duplicates finalPath)) " ----> "))                           ;Send distance message in the result frame
                                      (send distance_message set-label  (string-append (string-append "Distance: " (number->string distance )) " miles"))   ;Send distance message in the result frame
                                      
                                      (send time_message set-label  (string-append                                                                          ;Send time message in the result frame
                                                                     (string-append
                                                                      (string-append
                                                                       (string-append "Arive in: " (number->string h )) " hours and ") (number->string m)) " minuts."))    
                                      
                                      (send resultFrame show #t))                               ;Call result frame

                                     ;_______________________________________________________________________________________________________________________________________________

                                     
                                    (else (send msg set-label "Select stations please!"))))]    ;Message to User, in case stations are not chosen
                      [vert-margin 10]                                                          ;Vertical distance from other items
                      [style (list 'border)]))                                                  ;Adding border to panel



(define btn_reset (new button%                                                                  ;Reset Button
                      [label "Reset"]                                                           ;Button label
                      [parent h_panel]                                                          ;Parent is horizontal panel
                      [callback (lambda (button event)                                          ;Actions in case of button pressing
                         (send msg set-label "")                                                ;Cleaning the lines of choice
                                  (send start set-string-selection emptyLine)
                                  (send finish set-string-selection emptyLine))]
                      [vert-margin 10]))



(define msg (new message% [parent v_panel] [label ""] [auto-resize #t]))                        ;Message for app status

(new message% [parent resultFrame] [vert-margin 20] [label "Your Path: "])                      ;Title for the result panel



(define result_h_panel (new horizontal-panel%                               ;Panel for path result
                     [parent resultFrame]                                   ;Parent is Result Frame
                     [min-height 60]                                        
                     [style (list 'border)]
                     [border 50]
                     [alignment (list 'center 'center)]))


(define pathMessage (new message%                                           ;Message for path result
                   [parent result_h_panel]
                   [horiz-margin 30]
                   [label ""]
                   [auto-resize #t]))


(define distance_message (new message%                                      ;Message for distance result
                              [parent resultFrame]
                              [vert-margin 20]
                              [horiz-margin 30]
                              [label ""]
                              [auto-resize #t]))

(define time_message (new message%                                          ;Message for time result
                          [parent resultFrame]
                          [horiz-margin 30]
                          [label ""]
                          [auto-resize #t]))



(define btn_back (new button%                                               ;Close button
                      [label "Close"]
                      [parent resultFrame]
                      [callback (lambda (button event)   (send  resultFrame show #f)) ]
                      [vert-margin 30]))




(send mainFrame show #t)                                                    ;Calling of main frame


