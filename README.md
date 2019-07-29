# BuyMyFurniture
Project for course PIDM

---------------------------------------------------------------------------------------------------

                       BuyMyFurniture readme.txt
	                      Written by Shelby Kurz

----------------------------------------------------------------------------------------------------

This project was created and coded by Shelby Kurz (sskurz@rutgers.edu) 
and earned a 100 as the final grade

This project was created for the Rutgers University
course CS336 "Principles of Information and Data 
Management" taught by Professor Antonio Miranda

Submitted: April 2019



---------------------- Necessary credentials -------------------------------
-------- URL
http://ec2-18-221-239-241.us-east-2.compute.amazonaws.com:8080/BuyMyFurniture/


-------- EC2 Credentials
/////////////////

-------- Tomcat Credentials
/////////////////


-------- Database Endpoint
/////////////////



------------------------------- BuyMyFurniture Logins -----------------------------------
-------- user account example (shelby's)
* this has some emails and wishlist things filled out already
username: sskurz
pass: geraldine


------------------------------- FEATURE CHECKLIST -----------------------------------
This project includes all basic and advanced features from the checklist provided to us:


----------------I. Create accounts of users; login, logout.

----------------II. Auctions
   
Sellers are able to create an auction (set all characteristics of item, pick auction
duration, and determine a hidden minimum price)

Users can then bid on the auction, either setting a static manual bid or determining
an upper limit that they are willing to pay, and if someone places a new bid on the
auction, auto pay will kick in (manual vs. auto, auto vs. manual, auto vs auto cases
have all been programmed for). 

When auctions are first created, an event is sent to the database. When the 
auction end date/time has been reached, the event kicks into place and closes
the auction, then decides if the auction had a winner (top bid > minimum price
if there was one). If it has a winner, the auction is set to a "was sold" status, and an
email is sent to both the top bid winner and the seller.
If there was no winner, the seller is emailed.

----------------III Browsing and advanced search functionality
    
Users are able to manually search both items(and their auctions) and users.
They may also generate lists of auctions sorted by different criteria, including
active and sold auctions.
For any user that is looked up, their entire auction and bidding history is also displayed.
For any auction viewed, a history of bids is displayed and the option to view similar
past auctions from at least one month prior is given 


----------------IV Alerts and Messaging functions
BuyMyFurnitureAlerts will message users if another higher bid has been placed
In the case of two autobids bidding against each other, the email will only send
at the end of the cycle, and will only email the losing bidder (thus no spamming
of inboxes). The entire history of autobidding will be available to see on the 
auctions page.

User's can define types of items that are added to the wishlist
Every time someone posts an item for auction, that item is compared
to user's wishlists and if a match is made, the item is removed from the 
wishlist and the user is emailed by WishlistAlert

User's can post questions on the Forums. Users may select a question from
the list to see a list of responses to the question.
Users may also search the forums for up to 5 keywords that may be 
included either questions or answers.


----------------V Customer representatives and admin functions
Admin account has been made. In addition to having all of the functions
of a rep, they uniquely can generate sales reports based on auctions
that are closed and were sold. This includes total earnings, earnings
per item, per item type, per end user, best selling items, best selling users,
and best buyers. Admins can also create customer rep accounts.

Users are able to send an email to a random representative, and the 
rep can answer these questions by emailing back. Reps can also
edit users by looking them up in the Search Users function, and chosing to edit them. 
Note that only Admin can delete users, and cannot delete itself.
Reps can also edit/delete auctions and bids when viewing them.
