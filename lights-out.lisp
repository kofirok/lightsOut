;; Khalid Kofiro P3 Lisp Lights-Out Game

;; To play uncomment play-game and load the file
;; To watch the AI play uncomment watch-ai-play and load the file

 ;; (play-game)
 ;;(watch-ai-play) 

;; The print-board function takes a list of 9 integers and prints
;; them in a 3x3 grid format, with each row on a new line.

(defun print-board (board)
  (if (= 0 (mod (length board) 4))
      (format t "~% ~a" (car board))
      (format t " ~a" (car board)))
  (if (null (rest board))
      nil
      (print-board (rest board))))

;; The flip-switch function takes a board and a light argument, and flips the light at the 
;; specified position on the board. The function is implemented using recursion and conses a 
;; new list with the flipped light.

(defun flip-switch (board light)
  (if (zerop light)
      (cons (if (zerop (car board)) 1 0) (rest board))
      (cons (car board) (flip-switch (rest board) (- light 1)))))

;; The lights-off function takes a board argument and checks if all the lights on the board are off. 
;; It uses recursion and the and operator to check if the current light is off and the rest of the 
;; board is also off.

(defun lights-off (board)
  (if (null board)
      t
      (and (zerop (car board))
           (lights-off (cdr board)))))

;; The play-game function starts the game "Lights Out". It generates a random 3x3 board of lights 
;; and prompts the user to flip switches to turn off all the lights, keeping track of the number 
;; of moves taken to win.

(defun play-game ()
  (format t "~%Welcome to Lights Out!~%")    ;; Prints a welcome message
  (let ((board (loop repeat 9 collect (random 2))) ;; Creates a 9-element list of 0s and 1s randomly
        (switch 1)    ;; Initializes switch to 1
        (moves 0))    ;; Initializes moves to 0
    (loop while (not (lights-off board)) do   ;; Continues the loop until all lights are off
      (progn
        (print-board board)    ;; Prints the current state of the board
        (format t "~%Enter a switch to flip (1 to 8, or 0 to exit): ")
        (setf switch (read))   ;; Reads user input for what switch to flip
        (cond ((and (>= switch 1) (<= switch 9)) ;; Checks if the input is between 1 and 9
               (setf board (flip-switch board (- switch 1))) ;; Flips the switch using the input from the user
               (incf moves))   ;; Increases the move count
              ((= switch 0)   ;; If the input is 0
               (return-from play-game))   ;; Exits the loop and function (End game option)
              (t
               (format t "~%Invalid input. Try again."))))   ;; If the input is invalid, prompts the user to try again
      )
    (format t "~% ")  
    (print-board board)   ;; Prints the final state of the board
    (format t "~%All lights are off! You won in ~D moves!~%" moves)))   ;; Prints the final message with the move count.

;; The ai-move function uses a loop to find the first light (1) that is currently on, 
;; then picks it by returning the index of the light it found.
(defun ai-move (board)
  (let ((index 0))
    (loop for i from 0 below 16
          until (= (nth i board) 1) do
          (incf index))
    (+ index 1))) ;; Since we are using 1-9, we add 1 to the index

(defun watch-ai-play ()
  (format t "%Welcome to Lights Out!%")
  (let ((board (loop repeat 16 collect (random 2)))
        (moves 0))
    (loop while (not (lights-off board)) do
      (progn
        (print-board board)
        (format t "~%   ")
        (format t "% AI is picking...")
        (sleep 1) ;; Added sleep function so that the moves of the AI are visible to the user
        (let ((switch (ai-move board)))
          (setf board (flip-switch board (- switch 1)))
          (incf moves))))
    (format t "~% ")      
    (print-board board)
    (format t "~%All lights are off! The AI won in ~D moves!%" moves)))

;;------------------------------------------------------------------------------------------------------------------

;; Testing

;; The testing sections include tests to validate the functionality of the main functions. 
;; The test-lights-out function runs all tests if all the tests pass and prints the test result.

(defun test-flip-switch ()
  (let ((board '(1 0 0 0 0 0 0 0 0)))
    (let ((new-board (flip-switch board 0)))
      (let ((expected '(0 0 0 0 0 0 0 0 0))) ;; If the new-board = the expected board after the light is 
        (equal new-board expected)))))       ;; switched, then it passes, if not it fails.

(defun test-lights-off ()
  (let ((board '(0 0 0 0)))
    (let ((expected t)) ;; If all are 0's then test passes, adjust to 1 and it fails.
      (equal (lights-off board) expected))))

(defun test-input ()
  (let ((input 5)) ;; Adjust expected input here
    (let ((user-input (read)))
      (let ((expected (equal user-input input))) ;; if the user inputs the number specified it passes,
        expected))))                             ;; if not it fails.
                                   
(defun test-ai-move () ;; Checks if an AI move is valid using the valid-move function
  (let ((board (loop repeat 10 collect (random 2))))
    (valid-move (ai-move board))))

(defun valid-move (number) ;; Determines if a move is a valid (1-9)
  (and (<= 1 number) (<= number 9)))

(defun test-lights-out ()
  (format t "Enter the number 5 to test input: ")
  (let ((result3 (test-input))
        (result1 (test-flip-switch))
        (result2 (test-lights-off))
        (result4 (test-ai-move)))
    (let ((finalresult (and result1 result2 result3 result4))) 
      (if finalresult                 
          (format t "All tests passed!~%")           ;; If all the tests pass, then it passes. 
          (format t "One or more tests failed.~%"))))) ;; If one or more tests fail, it fails.

;; (test-lights-out)    