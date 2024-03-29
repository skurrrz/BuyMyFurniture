<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!-- 
See createNewAuction.jsp for details about this entire folder

This file checks that the auction is valid, then inserts it into Auctions Table

AUCTION CLOSING PROCEDURE:
When an auction is successfully created and inserted into the database, an alert
is also created and inserted into the database, and after the duration of the auction,
it automatically sets the auction to closed, then
	IF the top bid was greater than the minimum sell price
		Email both seller and bidder and set wasSold to true
	ELSE
		Email the seller and set wasSold to false
 -->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" type="text/css" href="../../css/home.css">
		<title>Please wait...</title>
	</head>
	
<body>
		<!-----------------------------------------------------------------------------------------------
			             PARAMETERS OBTAINED FROM getAuctionInfo.jsp
			      Note: 
			  - AuctionID is generated by taking the current date and time and converting 
			    	it into an int
			  - Calendar is used to get end of auction (start + duration)
			  - if a minimum sell price was input, and it is less than the starting bid, 
			  		replace it with the starting bid
		------------------------------------------------------------------------------------------------->

	<%
	String newItemType = request.getParameter("item_type");
	String newItemManufacturer = request.getParameter("item_manufacturer");
	String newItemCondition = request.getParameter("item_condition");
	String newItemColor = request.getParameter("item_color");
	String newItemMaterial = request.getParameter("item_material");
	
	int newAuctionID = (int)((new java.util.Date().getTime() / 1000L) % Integer.MAX_VALUE);
	String newAuctionSellerID = session.getAttribute("user_username").toString();
	String newAuctionTitle = request.getParameter("auction_title");
	String newAuctionItemCategory = session.getAttribute("item_category").toString();
	double newAuctionStartingBid = Float.parseFloat(request.getParameter("auction_starting_bid"));
	double newAuctionMinimumSellPrice = Float.parseFloat(request.getParameter("auction_minimum_sell_price"));
	double newAuctionBidIncrements = Float.parseFloat(request.getParameter("auction_bid_increments"));
	int newAuctionDuration = Integer.parseInt(request.getParameter("auction_duration"));
	
	Calendar cal = Calendar.getInstance();
	java.sql.Timestamp newAuctionStartDate = new java.sql.Timestamp(cal.getTimeInMillis());
	cal.add(Calendar.DATE, newAuctionDuration);
	java.sql.Timestamp newAuctionEndDate = new java.sql.Timestamp(cal.getTimeInMillis());

	if (newAuctionMinimumSellPrice < newAuctionStartingBid){
		newAuctionMinimumSellPrice = newAuctionStartingBid;
	}
	
	%>
	<!-----------------------------------------------------------------------------------------------
    				QUERIES DATABASE TO CHECK IF AUCTION IS A VALID ENTRY
	------------------------------------------------------------------------------------------------>
	<%
//	try {
		String url = "jdbc:mysql://dbshelbyxavier.cyapumk1qqju.us-east-2.rds.amazonaws.com:3306/BuyMyFurniture";
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "shelbyxavier", "kurzlarosa");
		Statement stmt = con.createStatement();
		
		%>	
		<!-----------------------------------------------------------------------------------------------
				                             CHAIRS
		------------------------------------------------------------------------------------------------>		
		<%		
		if(newAuctionItemCategory.equals("chair")){
			String newItemFabric = request.getParameter("chair_fabric");
			String newItemNumLegs = request.getParameter("chair_num_legs");
			
			
			//INSERT INTO Auctions
			String insertAuction = "INSERT INTO Auctions (auctionID, seller, title, item_category, starting_bid, minimum_sell_price, "
					+ "bid_increments, auction_startDate, auction_endDate, isActive, wasSold, imageURL)"
					+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 0, null)";
			
			PreparedStatement ps = con.prepareStatement(insertAuction);
			ps.setInt(1, newAuctionID); 
			ps.setString(2, newAuctionSellerID); 
			ps.setString(3, newAuctionTitle);
			ps.setString(4, newAuctionItemCategory);
			ps.setDouble(5, newAuctionStartingBid);
			ps.setDouble(6, newAuctionMinimumSellPrice);
			ps.setDouble(7, newAuctionBidIncrements);
			ps.setTimestamp(8, newAuctionStartDate);
			ps.setTimestamp(9, newAuctionEndDate);
			ps.executeUpdate();
			
			
			//INSERT INTO Items
			String insertItem = "INSERT INTO Items (auctionID, item_type, item_manufacturer, item_condition, item_color, item_material, lamp_light_type, lamp_num_bulbs, chair_fabric, chair_num_legs, table_shape, table_num_legs)"
					+ " VALUES (?, ?, ?, ?, ?, ?, null, null, ?, ?, null, null)";
			
			PreparedStatement ps2 = con.prepareStatement(insertItem);
			ps2.setInt(1, newAuctionID); 
			ps2.setString(2, newItemType); 
			ps2.setString(3, newItemManufacturer);
			ps2.setString(4, newItemCondition);
			ps2.setString(5, newItemColor);
			ps2.setString(6, newItemMaterial);
			ps2.setString(7, newItemFabric);
			ps2.setString(8, newItemNumLegs);
			ps2.executeUpdate();
			
			//COMPARE TO WISHLIST - EMAIL USER IF THIS ITEM MATCHES THEIR WISHLIST ITEM
			//If I had more time I would've made a Trigger in Database so won't use up user's time
			String queryWishlist= "SELECT * FROM Wishlist WHERE item_category = 'chair' or item_category = 'any';";
			ResultSet WishRes = stmt.executeQuery(queryWishlist);			
			
				if(WishRes.next()){
					WishRes.beforeFirst();
					while(WishRes.next()){
						//number of matches
						int numMatches = 0;
						//number categories where Any or Null
						int requiredNumMatches = 7;
						String wishID = (WishRes.getString("wishID"));
						
						if(newItemType.equals(WishRes.getString("item_type"))){
							numMatches++;
							} else if ( (WishRes.getString("item_type").equals("Any")) 
									|| (newItemType.equals("Unknown"))
									|| (newItemType.equals("unknown"))
									|| (WishRes.getString("item_type") == null) ){
								requiredNumMatches--;
							}
						
						if(newItemManufacturer.equals(WishRes.getString("item_manufacturer"))){
							numMatches++;
							} else if ( (WishRes.getString("item_manufacturer").equals("Any")) 
									|| (newItemManufacturer.equals("Unknown"))
									|| (newItemManufacturer.equals("unknown"))
									|| (WishRes.getString("item_manufacturer") == null) ){
								requiredNumMatches--;
							}
						
						if(newItemCondition.equals(WishRes.getString("item_condition"))){
							numMatches++;
							} else if ( (WishRes.getString("item_condition").equals("Any")) || (WishRes.getString("item_condition") == null) ){
								requiredNumMatches--;
							}
						
						if(newItemColor.equals(WishRes.getString("item_color"))){
							numMatches++;
							} else if ( (WishRes.getString("item_color").equals("Any")) 
									|| (newItemColor.equals("Unknown"))
									|| (newItemColor.equals("unknown"))
									|| (WishRes.getString("item_color") == null) ){
								requiredNumMatches--;
							}
						
						if(newItemMaterial.equals(WishRes.getString("item_material"))){
							numMatches++;
							} else if ( (WishRes.getString("item_material").equals("Any")) 
									|| (newItemMaterial.equals("Unknown"))
									|| (newItemMaterial.equals("unknown"))
									|| (WishRes.getString("item_material") == null) ){
								requiredNumMatches--;
							}
						
						if (WishRes.getString("chair_fabric")== null){
							requiredNumMatches--;
						} else if ((WishRes.getString("chair_fabric").equals("Any"))
								|| (newItemFabric.equals("Unknown"))
								|| (newItemFabric.equals("unknown"))){
							requiredNumMatches--;
						} else if (newItemFabric.equals(WishRes.getString("chair_fabric"))){
							numMatches++;
						}
						
						if (WishRes.getString("table_num_legs")== null){
							requiredNumMatches--;
						} else if (WishRes.getString("table_num_legs").equals("Any")){
							requiredNumMatches--;
						} else if (newItemNumLegs.equals(WishRes.getString("table_num_legs"))){
							numMatches++;
						}
						
						
						//After checking all attributes
						if(requiredNumMatches == numMatches){
							String wishUser = WishRes.getString("username");
						
							String emailWishlist = "INSERT INTO Email"
									+ " VALUES (?, ?, ?, ?, ?)";
							
							PreparedStatement psW = con.prepareStatement(emailWishlist);
							psW.setString(1, "WishlistAlert"); 
							psW.setString(2, wishUser); 
							psW.setTimestamp(3, newAuctionStartDate);
							psW.setString(4, "An item in your wishlist has been posted");
							psW.setString(5, "An item has been posted for auction that matches an item in your wishlist!"
												+ " Please visit auction #" + newAuctionID + " to see the item. This"
												+ " wish has been removed from your wishlist.");
							psW.executeUpdate();
							
							//delete from wishlist		
							String deleteWish = "DELETE FROM Wishlist WHERE wishID = '" + wishID + "';";		
							PreparedStatement deleteWishp = con.prepareStatement(deleteWish);
							deleteWishp.executeUpdate();		
							con.close();		
							break;
						}
					}
				}
			
			
			
			//CREATE EVENT TO END AUCTION - This could have been simplified if I had more time (ssk)
			String createEvent = "CREATE EVENT IF NOT EXISTS closeAuction" + newAuctionID + " ON SCHEDULE AT CURRENT_TIMESTAMP"
					+ " + INTERVAL '" + newAuctionDuration + "' DAY DO BEGIN UPDATE Auctions SET isActive = '0'"
					+ " WHERE auctionID = '" + newAuctionID + "';"
					+ " IF ((SELECT t1.topBid FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM"
					+ " Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS"
					+ " topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID AND topBid = t2.bid_amount"
					+ " WHERE a.auctionID = '" + newAuctionID + "') >= (SELECT a.minimum_sell_price FROM Auctions a LEFT JOIN (SELECT"
					+ " auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID"
					+ " LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID"
					+ " AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN INSERT INTO Email VALUES"
					+ " ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Congratulations! You have the winning bid!',"
					+ " 'Your bid on auction #" + newAuctionID + " was the winning bid! The seller will contact you for purchasing information.');"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + a.seller + '', CURRENT_TIMESTAMP,'Congratulations! Your item has"
					+ " sold!', 'Your auction #" + newAuctionID + " was sold! Please email top bidder ' + t2.topBidder + ' for payment request.'); UPDATE"
					+ " Auctions SET wasSold = '1' WHERE auctionID = '" + newAuctionID + "'; END; END IF; IF ((SELECT t1.topBid FROM Auctions"
					+ " a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID"
					+ " = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID"
					+ " = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "') <(SELECT a.minimum_sell_price"
					+ " FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON"
					+ " a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON"
					+ " a.auctionID = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Your auction #" + newAuctionID
					+ " has ended without a seller', 'Your auction #" + newAuctionID + " has ended without reaching a high enough bid to sell"
					+ " your item. Please feel free to upload your item again into a new auction!'); END; END IF; END;";
				
			PreparedStatement ps3 = con.prepareStatement(createEvent);
			ps3.executeUpdate();
			con.close();
			
			%> 
			<script> 
				alert("Success! Your auction has been posted.");
			    window.location.href = "../auctionsHome.jsp";
			</script>

		<!-----------------------------------------------------------------------------------------------
				                             TABLES
		------------------------------------------------------------------------------------------------>		
		<%	
		} else if (newAuctionItemCategory.equals("table")) {
			String newItemShape = request.getParameter("table_shape");
			String newItemNumLegs = request.getParameter("table_num_legs");
			
			//INSERT INTO Auctions
			String insertAuction = "INSERT INTO Auctions (auctionID, seller, title, item_category, starting_bid, minimum_sell_price, bid_increments, auction_startDate, auction_endDate, isActive, wasSold, imageURL)"
					+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 0, null)";
			
			PreparedStatement ps = con.prepareStatement(insertAuction);
			ps.setInt(1, newAuctionID); 
			ps.setString(2, newAuctionSellerID); 
			ps.setString(3, newAuctionTitle);
			ps.setString(4, newAuctionItemCategory);
			ps.setDouble(5, newAuctionStartingBid);
			ps.setDouble(6, newAuctionMinimumSellPrice);
			ps.setDouble(7, newAuctionBidIncrements);
			ps.setTimestamp(8, newAuctionStartDate);
			ps.setTimestamp(9, newAuctionEndDate);
			ps.executeUpdate();
			
			//INSERT INTO Items
			String insertItem = "INSERT INTO Items (auctionID, item_type, item_manufacturer, item_condition, item_color, item_material, lamp_light_type, lamp_num_bulbs, chair_fabric, chair_num_legs, table_shape, table_num_legs)"
					+ " VALUES (?, ?, ?, ?, ?, ?, null, null, null, null, ?, ?)";
			PreparedStatement ps2 = con.prepareStatement(insertItem);
			ps2.setInt(1, newAuctionID); 
			ps2.setString(2, newItemType); 
			ps2.setString(3, newItemManufacturer);
			ps2.setString(4, newItemCondition);
			ps2.setString(5, newItemColor);
			ps2.setString(6, newItemMaterial);
			ps2.setString(7, newItemShape);
			ps2.setString(8, newItemNumLegs);
			ps2.executeUpdate();

			//COMPARE TO WISHLIST
			String queryWishlist= "SELECT * FROM Wishlist WHERE item_category = 'table' or item_category = 'any';";
			ResultSet WishRes = stmt.executeQuery(queryWishlist);			
			
				if(WishRes.next()){
					WishRes.beforeFirst();
					while(WishRes.next()){
						//number of matches
						int numTableMatches = 0;
						//number categories where Any or Null
						int requiredNumTableMatches = 7;
						String wishID = (WishRes.getString("wishID"));
						
						if(newItemType.equals(WishRes.getString("item_type"))){
							numTableMatches++;
							} else if ( (WishRes.getString("item_type").equals("Any")) 
									|| (newItemType.equals("Unknown"))
									|| (newItemType.equals("unknown"))
									|| (WishRes.getString("item_type") == null) ){
								requiredNumTableMatches--;
							}
						
						if(newItemManufacturer.equals(WishRes.getString("item_manufacturer"))){
							numTableMatches++;
							} else if ( (WishRes.getString("item_manufacturer").equals("Any")) 
									|| (newItemManufacturer.equals("Unknown"))
									|| (newItemManufacturer.equals("unknown"))
									|| (WishRes.getString("item_manufacturer") == null) ){
								requiredNumTableMatches--;
							}
						
						if(newItemCondition.equals(WishRes.getString("item_condition"))){
							numTableMatches++;
							} else if ( (WishRes.getString("item_condition").equals("Any")) 
									|| (WishRes.getString("item_condition") == null) ){
								requiredNumTableMatches--;
							}
						
						if(newItemColor.equals(WishRes.getString("item_color"))){
							numTableMatches++;
							} else if ( (WishRes.getString("item_color").equals("Any")) 
									|| (newItemColor.equals("Unknown"))
									|| (newItemColor.equals("unknown"))
									|| (WishRes.getString("item_color") == null) ){
								requiredNumTableMatches--;
							}
						
						if(newItemMaterial.equals(WishRes.getString("item_material"))){
							numTableMatches++;
							} else if ( (WishRes.getString("item_material").equals("Any")) 
									|| (newItemMaterial.equals("Unknown"))
									|| (newItemMaterial.equals("unknown"))
									|| (WishRes.getString("item_material") == null) ){
								requiredNumTableMatches--;
							}					
						
						if (WishRes.getString("table_shape") == null){
							requiredNumTableMatches--;
						} else if ( (WishRes.getString("table_shape").equals("Any"))
								|| (newItemShape.equals("Unknown"))
								|| (newItemShape.equals("unknown"))){
							requiredNumTableMatches--;
						} else if (newItemShape.equals(WishRes.getString("table_shape"))){
							numTableMatches++;
						}
						
						if (WishRes.getString("table_num_legs") == null){
							requiredNumTableMatches--;
						} else if (WishRes.getString("table_num_legs").equals("Any")){
							requiredNumTableMatches--;
						} else if (newItemNumLegs.equals(WishRes.getString("table_num_legs"))){
							numTableMatches++;
						}

						
						//After checking all attributes
						if(requiredNumTableMatches == numTableMatches){
							String wishUser = WishRes.getString("username");
						
							String emailWishlist = "INSERT INTO Email"
									+ " VALUES (?, ?, ?, ?, ?)";
							
							PreparedStatement pswt = con.prepareStatement(emailWishlist);
							pswt.setString(1, "WishlistAlert"); 
							pswt.setString(2, wishUser); 
							pswt.setTimestamp(3, newAuctionStartDate);
							pswt.setString(4, "table An item in your wishlist has been posted");
							pswt.setString(5, "An item has been posted for auction that matches wishID #" + wishID + " in your wishlist!"
												+ " Please visit auction #" + newAuctionID + " to see the item. This"
												+ " wish has been removed from your wishlist.");
							pswt.executeUpdate();
									
							String deleteWish = "DELETE FROM Wishlist WHERE wishID = '" + wishID + "';";		
							PreparedStatement deleteWishp = con.prepareStatement(deleteWish);
							deleteWishp.executeUpdate();	
							
							break;
						}
					}		
				}
			
			//CREATE EVENT TO END AUCTION - This could have been simplified if I had more time (ssk)
			String createEvent = "CREATE EVENT IF NOT EXISTS closeAuction" + newAuctionID + " ON SCHEDULE AT CURRENT_TIMESTAMP"
					+ " + INTERVAL '" + newAuctionDuration + "' DAY DO BEGIN UPDATE Auctions SET isActive = '0'"
					+ " WHERE auctionID = '" + newAuctionID + "';"
					+ " IF ((SELECT t1.topBid FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM"
					+ " Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS"
					+ " topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID AND topBid = t2.bid_amount"
					+ " WHERE a.auctionID = '" + newAuctionID + "') >= (SELECT a.minimum_sell_price FROM Auctions a LEFT JOIN (SELECT"
					+ " auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID"
					+ " LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID"
					+ " AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN INSERT INTO Email VALUES"
					+ " ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Congratulations! You have the winning bid!',"
					+ " 'Your bid on auction #" + newAuctionID + " was the winning bid! The seller will contact you for purchasing information.');"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + a.seller + '', CURRENT_TIMESTAMP,'Congratulations! Your item has"
					+ " sold!', 'Your auction #" + newAuctionID + " was sold! Please email top bidder ' + t2.topBidder + ' for payment request.'); UPDATE"
					+ " Auctions SET wasSold = '1' WHERE auctionID = '" + newAuctionID + "'; END; END IF; IF ((SELECT t1.topBid FROM Auctions"
					+ " a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID"
					+ " = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID"
					+ " = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "') <(SELECT a.minimum_sell_price"
					+ " FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON"
					+ " a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON"
					+ " a.auctionID = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Your auction #" + newAuctionID
					+ " has ended without a seller', 'Your auction #" + newAuctionID + " has ended without reaching a high enough bid to sell"
					+ " your item. Please feel free to upload your item again into a new auction!'); END; END IF; END;";
				
			PreparedStatement ps3 = con.prepareStatement(createEvent);
			ps3.executeUpdate();
			con.close();

			%> 
			<script> 
				alert("Success! Your auction has been posted.");
			    window.location.href = "../auctionsHome.jsp";
			</script>

		<!-----------------------------------------------------------------------------------------------
				                             LAMPS
		------------------------------------------------------------------------------------------------>		
		<%	
		} else if (newAuctionItemCategory.equals("lamp")) {
			String newItemLightType = request.getParameter("lamp_light_type");
			String newItemNumBulbs = request.getParameter("lamp_num_bulbs");
			
			//INSERT INTO Auctions
			String insertAuction = "INSERT INTO Auctions (auctionID, seller, title, item_category, starting_bid, minimum_sell_price, bid_increments, auction_startDate, auction_endDate, isActive, wasSold, imageURL)"
					+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 0, null)";
			
			PreparedStatement ps = con.prepareStatement(insertAuction);
			ps.setInt(1, newAuctionID); 
			ps.setString(2, newAuctionSellerID); 
			ps.setString(3, newAuctionTitle);
			ps.setString(4, newAuctionItemCategory);
			ps.setDouble(5, newAuctionStartingBid);
			ps.setDouble(6, newAuctionMinimumSellPrice);
			ps.setDouble(7, newAuctionBidIncrements);
			ps.setTimestamp(8, newAuctionStartDate);
			ps.setTimestamp(9, newAuctionEndDate);
			ps.executeUpdate();
			
			//INSERT INTO Items
			String insertItem = "INSERT INTO Items (auctionID, item_type, item_manufacturer, item_condition, item_color, item_material, lamp_light_type, lamp_num_bulbs, chair_fabric, chair_num_legs, table_shape, table_num_legs)"
					+ " VALUES (?, ?, ?, ?, ?, ?, ?, ?, null, null, null, null)";
			PreparedStatement ps2 = con.prepareStatement(insertItem);
			ps2.setInt(1, newAuctionID); 
			ps2.setString(2, newItemType); 
			ps2.setString(3, newItemManufacturer);
			ps2.setString(4, newItemCondition);
			ps2.setString(5, newItemColor);
			ps2.setString(6, newItemMaterial);
			ps2.setString(7, newItemLightType);
			ps2.setString(8, newItemNumBulbs);		
			ps2.executeUpdate();

			//COMPARE TO WISHLIST - EMAIL USER IF THIS MATCHES A WISHLIST ENTRY
			String queryWishlist= "SELECT * FROM Wishlist WHERE item_category = 'lamp' or item_category = 'any';";
			ResultSet WishRes = stmt.executeQuery(queryWishlist);			
			
				if(WishRes.next()){
					WishRes.beforeFirst();
					while(WishRes.next()){
						//number of matches
						int numLampMatches = 0;
						//number categories where Any or Null
						int requiredLampNumMatches = 7;
						String wishID = (WishRes.getString("wishID"));
						
						if(newItemType.equals(WishRes.getString("item_type"))){
							numLampMatches++;
							} else if ( (WishRes.getString("item_type").equals("Any")) 
									|| (newItemType.equals("Unknown"))
									|| (newItemType.equals("unknown"))
									|| (WishRes.getString("item_type") == null) ){
								requiredLampNumMatches--;
							}
						
						if(newItemManufacturer.equals(WishRes.getString("item_manufacturer"))){
							numLampMatches++;
							} else if ( (WishRes.getString("item_manufacturer").equals("Any")) 
									|| (newItemManufacturer.equals("Unknown"))
									|| (newItemManufacturer.equals("unknown"))
									|| (WishRes.getString("item_manufacturer") == null) ){
								requiredLampNumMatches--;
							}
						
						if(newItemCondition.equals(WishRes.getString("item_condition"))){
							numLampMatches++;
							} else if ( (WishRes.getString("item_condition").equals("Any")) || (WishRes.getString("item_condition") == null) ){
								requiredLampNumMatches--;
							}
						
						if(newItemColor.equals(WishRes.getString("item_type"))){
							numLampMatches++;
							} else if ( (WishRes.getString("item_color").equals("Any")) 
									|| (newItemColor.equals("Unknown"))
									|| (newItemColor.equals("unknown"))
									|| (WishRes.getString("item_color") == null) ){
								requiredLampNumMatches--;
							}
						
						if(newItemMaterial.equals(WishRes.getString("item_material"))){
							numLampMatches++;
							} else if ( (WishRes.getString("item_material").equals("Any")) 
									|| (newItemMaterial.equals("Unknown"))
									|| (newItemMaterial.equals("unknown"))
									|| (WishRes.getString("item_material") == null) ){
								requiredLampNumMatches--;
							}
						
						if (WishRes.getString("lamp_light_type")== null){
								requiredLampNumMatches--;
							} else if ((WishRes.getString("lamp_light_type").equals("Any"))
								|| (newItemLightType.equals("Unknown"))
								|| (newItemLightType.equals("unknown"))){
								requiredLampNumMatches--;
							} else if (newItemLightType.equals(WishRes.getString("lamp_light_type"))){
								numLampMatches++;
							}
						
						if (WishRes.getString("lamp_num_bulbs")== null){
								requiredLampNumMatches--;
							} else if (WishRes.getString("lamp_num_bulbs").equals("Any")){
								requiredLampNumMatches--;
							} else if (newItemLightType.equals(WishRes.getString("lamp_num_bulbs"))){
								numLampMatches++;
							}

						
						//After checking all attributes
						if(requiredLampNumMatches == numLampMatches){
							String wishUser = WishRes.getString("username");
						
							String emailWishlist = "INSERT INTO Email"
									+ " VALUES (?, ?, ?, ?, ?)";
							
							PreparedStatement psw = con.prepareStatement(emailWishlist);
							psw.setString(1, "WishlistAlert"); 
							psw.setString(2, wishUser); 
							psw.setTimestamp(3, newAuctionStartDate);
							psw.setString(4, "Lamp An item in your wishlist has been posted");
							psw.setString(5, "An item has been posted for auction that matches an item in your wishlist!"
												+ " Please visit auction #" + newAuctionID + " to see the item. This"
												+ " wish has been removed from your wishlist.");
							psw.executeUpdate();
							
							String deleteWish = "DELETE FROM Wishlist WHERE wishID = '" + wishID + "';";		
							PreparedStatement deleteWishp = con.prepareStatement(deleteWish);
							deleteWishp.executeUpdate();
							break;
						}
					}
				}			
			
			
			
			//CREATE EVENT TO END AUCTION - This could have been simplified if I had more time (ssk)
			String createEvent = "CREATE EVENT IF NOT EXISTS closeAuction" + newAuctionID + " ON SCHEDULE AT CURRENT_TIMESTAMP"
					+ " + INTERVAL '" + newAuctionDuration + "' DAY DO BEGIN UPDATE Auctions SET isActive = '0'"
					+ " WHERE auctionID = '" + newAuctionID + "';"
					+ " IF ((SELECT t1.topBid FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM"
					+ " Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS"
					+ " topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID AND topBid = t2.bid_amount"
					+ " WHERE a.auctionID = '" + newAuctionID + "') >= (SELECT a.minimum_sell_price FROM Auctions a LEFT JOIN (SELECT"
					+ " auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID = t1.auctionID"
					+ " LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID = t2.auctionID"
					+ " AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN INSERT INTO Email VALUES"
					+ " ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Congratulations! You have the winning bid!',"
					+ " 'Your bid on auction #" + newAuctionID + " was the winning bid! The seller will contact you for purchasing information.');"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + a.seller + '', CURRENT_TIMESTAMP,'Congratulations! Your item has"
					+ " sold!', 'Your auction #" + newAuctionID + " was sold! Please email top bidder ' + t2.topBidder + ' for payment request.'); UPDATE"
					+ " Auctions SET wasSold = '1' WHERE auctionID = '" + newAuctionID + "'; END; END IF; IF ((SELECT t1.topBid FROM Auctions"
					+ " a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON a.auctionID"
					+ " = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON a.auctionID"
					+ " = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "') <(SELECT a.minimum_sell_price"
					+ " FROM Auctions a LEFT JOIN (SELECT auctionID, MAX(bid_amount) AS topBid FROM Bids GROUP BY auctionID) t1 ON"
					+ " a.auctionID = t1.auctionID LEFT JOIN (SELECT auctionID, bidder AS topBidder, bid_amount FROM Bids) t2 ON"
					+ " a.auctionID = t2.auctionID AND topBid = t2.bid_amount WHERE a.auctionID = '" + newAuctionID + "')) THEN BEGIN"
					+ " INSERT INTO Email VALUES ('BuyMyFurnitureAlerts', '' + t2.topBidder + '', CURRENT_TIMESTAMP,'Your auction #" + newAuctionID
					+ " has ended without a seller', 'Your auction #" + newAuctionID + " has ended without reaching a high enough bid to sell"
					+ " your item. Please feel free to upload your item again into a new auction!'); END; END IF; END;";
				
			PreparedStatement ps3 = con.prepareStatement(createEvent);
			ps3.executeUpdate();
			con.close();
			
			%> 
			<script> 
				alert("Success! Your auction has been posted.");
			    window.location.href = "../auctionsHome.jsp";
			</script>

		<!-----------------------------------------------------------------------------------------------
				                             ERROR
		------------------------------------------------------------------------------------------------>		
		<%	
		} else {
			con.close();	
			%> 	
			<script>
			    alert("An unexpected error has occurred. Please Try again.");
			    window.location.href = "createNewAuction.jsp";
			</script>
			<%	
		}
		
		
//	} catch (Exception ex) {
		%> 
		<script> 
//			alert(" Exception: An unexpected error has occurred. Please try again.");
//		    window.location.href = "createNewAuction.jsp";
		</script>
		<%
//	}
	%>

</body>
</html>