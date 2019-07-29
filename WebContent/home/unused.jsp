

SET SQL_SAFE_UPDATES = 0;
Delete from Bids where auctionID LIKE '1555971324';
SET SQL_SAFE_UPDATES = 1;
SELECT * from Bids where auctionID LIKE '1555971324';



<!---------------------------------- HOW THIS WORKS -----------------------------------------------------
See emails/emailHome.jsp for full details about the emails folder
	- This redirects from emailHome.jsp
	- Sends a new email with the new subject replaced with "RE: 'old_subject'" and the
		new recipient is the old email's sender
 ------------------------------------------------------------------------------------------------------->
 
 
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
 


 
 
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../home/home.jsp"><img src="../images/websiteLogo.png"></a></p>


	
	
				<div class='form'>
				  	<form>
				 		<button formaction="../searchForItems.jsp">Search For Another Item</button>
					 	<button formaction="../../home/home.jsp">Return Home</button>
				  	</form>	  	
				</div>	
	
	
	
	
	
	
					<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
					<script type="text/javascript">
					$(document).ready(function() {
					    $("#choose").on("change", function() {
					        if ($(this).val() === "other") {
					            $("#otherName").show();
					        }
					        else {
					            $("#otherName").hide();
					        }
					    });
					});
					</script>	
	
	
	
	
	
		<!-----------------------------------------------------------------------------------------------
					SESSION CHECK: If not logged in, return to login.jsp
		------------------------------------------------------------------------------------------------>
	<%
	String user_username;
	if(session.getAttribute("user_username") == null){
	   	%>
	   	<script>
	  			alert("User session check failed, please login!");
	  			window.location.href = "../login.jsp";
	  		</script>
	  		<%
	  		return;
	} else {
			user_username = session.getAttribute("user_username").toString();
	}
	%>	
	
	
							    
							    
USER NAME
String user_username = session.getAttribute("user_username").toString();
							    
				
				
				
					String url2 = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
					Class.forName("com.mysql.jdbc.Driver");
					Connection con2 = DriverManager.getConnection(url2, "shelbyxavier", "kurzlarosa");
					Statement stmt2 = con2.createStatement();
					
					String checkTopBid = "SELECT a.auctionID, a.seller, a.isActive, a.minimum_sell_price, t1.bidder, t1.topBid FROM" 
								+ " Auctions a LEFT JOIN (SELECT b.auctionID, MAX(b.bid_amount) AS topBid FROM Bids b WHERE b.auctionID LIKE '" + newAuctionID + "') t1"
								+ " ON a.auctionID LIKE t1.auctionID WHERE a.auctionID LIKE '" + newAuctionID + "';";
					ResultSet res2 = stmt2.executeQuery(checkTopBid);
					res2.next();
					String thisSeller = res2.getString("a.seller");
					String thisBuyer = res2.getString("t1.bidder");
					Calendar cal2 = Calendar.getInstance();
					java.sql.Timestamp newEmailDatetime = new java.sql.Timestamp(cal2.getTimeInMillis());
					
					if (res2.getDouble("t1.topBid") >= res2.getDouble("a.minimum_sell_price")){
						//Set Auction's wasSold as true
						String updateWasSold ="UPDATE Auctions SET wasSold = '1' WHERE auctionID LIKE '" + newAuctionID + "';";
						PreparedStatement psa = con.prepareStatement(updateWasSold);
						psa.executeUpdate();	
					
						//ALERT SELLER
						String insertEmailAlert1 = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)"
						+ " VALUES (?, ?, ?, ?, ?)";
				
						PreparedStatement psb = con.prepareStatement(insertEmailAlert1);
						psb.setString(1, "BuyMyFurnitureAlerts");
						psb.setString(2, thisSeller);
						psb.setTimestamp(3, newEmailDatetime);
						psb.setString(4, "Your Item has been Sold!");
						psb.setString(5, "Congratulations, your item from auction #" + newAuctionID + " has been sold! Please message "
								+ thisBuyer + " to finalize the payment method.");
						psb.executeUpdate();
						
						//ALERT BIDDER
						String insertEmailAlert2 = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)"
						+ " VALUES (?, ?, ?, ?, ?)";
				
						PreparedStatement psc = con.prepareStatement(insertEmailAlert2);
						psc.setString(1, "BuyMyFurnitureAlerts");
						psc.setString(2, thisBuyer);
						psc.setTimestamp(3, newEmailDatetime);
						psc.setString(4, "You have the winning bid!");
						psc.setString(5, "Congratulations, your bid on auction #" + newAuctionID + " is the winning bid!"
											+ " Please stand by for " + thisSeller + " to contact you for payment method.");
						psc.executeUpdate();
						con.close();

					} else {
						//ALERT BIDDER
						String insertEmailAlert3 = "INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent)"
						+ " VALUES (?, ?, ?, ?, ?)";
				
						PreparedStatement psd = con.prepareStatement(insertEmailAlert3);
						psd.setString(1, "BuyMyFurnitureAlerts");
						psd.setString(2, thisSeller);
						psd.setTimestamp(3, newEmailDatetime);
						psd.setString(4, "Your Item has been Sold!");
						psd.setString(5, "Congratulations, your item from auction #" + newAuctionID + " has been sold! Please message "
								+ thisBuyer + " to finalize the payment method.");
						psd.executeUpdate();
						con.close();			       
			    }
			    \
			    
			    

			    CREATE EVENT deactivate155569948344 ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1  DAY
			   
DO 
UPDATE Auctions a SET a.isActive = '0' WHERE a.auctionID = ‘newAuctionID’;
SELECT a.auctionID, a.seller, a.isActive, a.minimum_sell_price, t1.bidder, t1.topBid FROM Auctions a 
LEFT JOIN (SELECT b.auctionID, MAX(b.bid_amount) AS topBid FROM Bids b WHERE b.auctionID LIKE ‘newAuctionID’) t1 
ON a.auctionID LIKE t1.auctionID WHERE a.auctionID LIKE ‘1555612960’;
INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent) 


IF (t1.topBid >= a.minimum_sell_price)
	UPDATE Auctions a SET a.wasSold = '1' WHERE a.auctionID LIKE ‘newAuctionID’
	INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent) 
	VALUES ("BuyMyFurnitureAlerts", a.seller, CURRENT_TIMESTAMP , "Your Item has been Sold!", "Congratulations, your item from auction #a.auctionID has been sold! Please message " + t1.bidder + " to finalize the payment method.")	
	AND
	INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent) 
	VALUES ("BuyMyFurnitureAlerts", t1.bidder, CURRENT_TIMESTAMP , "You have the winning bid!", "Congratulations, your bid on auction #" + a.auctionID + " is the winning bid! Please stand by for " + a.seller + " to contact you for payment method.");	
	END IF
ELSE
	INSERT INTO Email (emailFrom, emailTo, emailDatetime, emailSubject, emailContent) VALUES ("BuyMyFurnitureAlerts", a.seller, CURRENT_TIMESTAMP , "Sorry, your item did not sell.", 
	"Hello, " + a.seller + ", unfortunately, your item from auction #" + a.auctionID + " has ended and did not get a high enough bid to sell. Please feel free to add this item to the auctions again.");
	END IF;
			    
			     -->