<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


 <!---------------------------------- HOW THIS WORKS -------------------------------------

 --------------------------------------------------------------------------------------->

<!DOCTYPE html>
<html>
	<head>
		<!-----------------------------------------------------------------------------------------------
			     CSS DETAILS HERE, IF FOLDER OR FILE IS MOVED MAKE SURE IT POINTS TO RIGHT LOCATION
		------------------------------------------------------------------------------------------------>
		<link rel="stylesheet" type="text/css" href="../css/home.css">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Wishlist</title>
	</head>
	
<body>
		<!-----------------------------------------------------------------------------------------------
			        HEADER IMAGE HERE, IF FOLDER OR FILE IS MOVED MAKE BOTH LINKS ARE FIXED
		------------------------------------------------------------------------------------------------>
		<p class="app-name"><a href="../home/home.jsp"><img src="../images/websiteLogo.png"></a></p>  
		 

		<!-----------------------------------------------------------------------------------------------
			        CATEGORY OF ITEM, RETRIEVED FROM searchForItems.jsp
		------------------------------------------------------------------------------------------------>	 
	<%
	String newItemCategory = request.getParameter("item_category");

	try {
	%>	
<!-----------------------------------------------------------------------------------------------
			        IF THE USER IS LOOKING FOR ANY CATEGORY
------------------------------------------------------------------------------------------------>	

		<%
		if(newItemCategory.equals("any")){
		%> 
		<div class="form">
   			<form class="allItemsSearch" method="post" action="check/checkAllWishlist.jsp">
	    	<h1> Item Wishlist </h1>
	    	<br>
	    	<hr>		
	      	<h3>What manufacturer are you looking for?</h3>
   				<select name="item_manufacturer" required onChange="check(this);">
   					<option value="Any">Any Manufacturer</option>
					<option value="Authentic Models">Authentic Models</option>
					<option value="Better Homes and Gardens">Better Homes and Gardens</option>
					<option value="Crate and Barrel">Crate and Barrel</option>
					<option value="Design Within Reach">Design Within Reach</option>
					<option value="Ethan Allen">Ethan Allen</option>
					<option value="Handy Living">Handy Living</option>
					<option value="IKEA">IKEA</option>
					<option value="La-Z-Boy">La-Z-Boy</option>
					<option value="Neiman Marcus">Neiman Marcus</option>
					<option value="Restoration Hardware">Restoration Hardware</option>
					<option value="Studio 55D">Studio 55D</option>
					<option value="Tommy Bahama">Tommy Bahama</option>
					<option value="Wholesale Interiors">Wholesale Interiors</option>
					<option value="Homemade">Homemade</option>
					<option value="Other">Other</option>
				</select>
				<div id="other-div" style="display:none;">
					<br>
			        <label>Enter the manufacturer you are looking for:  
			        <input id="other-input"></input></label>
			    </div>
				
				<h3>What condition are you looking for?</h3>
   				<select name="item_condition" required>
   					<option value="Any">Any Condition</option>
	   				<option value="New">New</option>
	   				<option value="Manufacturer Refurbished">Manufacturer Refurbished</option>
					<option value="Used/Like New">Used/Like New</option>
					<option value="Used/Acceptable">Used/Acceptable</option>
					<option value="For Parts/Not Working">For Parts/Not Working</option>
				</select>		
		
				
	      	<h3>What color are you looking for?</h3>
   				<select name="item_color" onChange="check2(this);" required>
   					<option value="Any">Any Color</option>
	   				<option value="White">White</option>
					<option value="Black">Black</option>
					<option value="Silver">Silver</option>
					<option value="Gold">Gold</option>
					<option value="Brown">Brown</option>
					<option value="Wood">Wood</option>
					<option value="Clear">Clear</option>				
					<option value="Red">Red</option>
					<option value="Orange">Orange</option>
					<option value="Yellow">Yellow</option>
					<option value="Green">Green</option>
					<option value="Blue">Blue</option>
					<option value="Purple">Purple</option>
					<option value="Pink">Pink</option>
					<option value="Multi-Color">Multi-Color</option>
					<option value="Other">Other</option>		
				</select>		
				<div id="other-div2" style="display:none;">
					<br>
			        <label>Enter the color you are looking for:  
			        <input id="other-input2"></input></label>
			    </div>				
			
	      	<h3>What type of material are you looking for?</h3>
   				<select name="item_material" onChange="check3(this);" required>
   					<option value="Any">Any Material</option>
   					<option value="Ash">Ash</option>
   					<option value="Birch">Birch</option>  
					<option value="Brass">Brass</option>   				
	   				<option value="Bronze">Bronze</option>
					<option value="Ceramic">Ceramic</option>
					<option value="Cherry">Cherry</option>	  
					<option value="Copper">Copper</option> 				
					<option value="Crystal">Crystal</option>	   				
					<option value="Glass">Glass</option>
					<option value="Iron">Iron</option>
					<option value="Mahogany">Mahogany</option>	
					<option value="Maple">Maple</option>	
					<option value="Marble">Marble</option>
					<option value="Pine">Pine</option>			
					<option value="Plastic">Plastic</option>
					<option value="Recycled Material">Recycled Material</option>	
					<option value="Steel">Steel</option>	
					<option value="Stone">Stone</option>
					<option value="Teak">Teak</option>
					<option value="Walnut">Walnut</option> 
					<option value="Wicker">Wicker</option>						
					<option value="Other">Other</option>
				</select>
				<div id="other-div3" style="display:none;">
					<br>
			        <label>Enter the type of material you are looking for:  
			        <input id="other-input3"></input></label>
				</div>
				<br><br>	
		      	<input type="submit" value="Add to Wishlist">
		    	</form>
			</div>
			<div class='form'>
			  	<form>
				 	<button formaction="../home/home.jsp">Return Home</button>
			  	</form>	  	
			</div>	
		

<!-----------------------------------------------------------------------------------------------
			        ELSE IF THE USER IS LOOKING FOR CHAIRS
------------------------------------------------------------------------------------------------>	
		<%
		} else if(newItemCategory.equals("chair")){
		%> 
  		<div class="form">
			<form class="chairSearch" method="post" action="check/checkChairWishlist.jsp">
		    	<h1> Chair Wishlist </h1>
		    	<br>
		    	<hr>	
	 	      	<h3>What type of chair are you looking for?</h3>
	   				<select name="item_type" onChange="check(this);" required>
	   					<option value="Any">Any Chair</option>   				
		   				<option value="Dining Chair">Dining Chair</option>
						<option value="Folding Chair">Folding Chair</option>
						<option value="Home Theater Chair">Home Theater Chair</option>
						<option value="Lawn Chair">Lawn Chair</option>	
						<option value="Reclining Chair">Reclining Chair</option>									
						<option value="Desk Chair">Desk Chair</option>		
						<option value="Rocking Chair">Rocking Chair</option>			
						<option value="Sofa Chair">Sofa Chair</option>
						<option value="Stool Chair">Stool Chair</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div" style="display:none;">
						<br>
				        <label>Enter the type of chair you are looking for:  
				        <input id="other-input"></input></label>
			        </div>	
				
		      	<h3>What manufacturer are you looking for?</h3>
	   				<select name="item_manufacturer" onChange="check2(this);" required>
	   					<option value="Any">Any Manufacturer</option>   				
						<option value="Authentic Models">Authentic Models</option>
						<option value="Better Homes and Gardens">Better Homes and Gardens</option>
						<option value="Crate and Barrel">Crate and Barrel</option>
						<option value="Design Within Reach">Design Within Reach</option>
						<option value="Ethan Allen">Ethan Allen</option>
						<option value="Handy Living">Handy Living</option>
						<option value="IKEA">IKEA</option>
						<option value="La-Z-Boy">La-Z-Boy</option>
						<option value="Neiman Marcus">Neiman Marcus</option>
						<option value="Restoration Hardware">Restoration Hardware</option>
						<option value="Studio 55D">Studio 55D</option>
						<option value="Tommy Bahama">Tommy Bahama</option>
						<option value="Wholesale Interiors">Wholesale Interiors</option>
						<option value="Homemade">Homemade</option>
						<option value="Other">Other</option>
					</select>	
					<div id="other-div2" style="display:none;">
						<br>
				        <label>Enter the manufacturer you are looking for:  
				        <input id="other-input2"></input></label>
					</div>	
					
					<h3>What condition are you looking for?</h3>
	   				<select name="item_condition" required>
	   					<option value="Any">Any Condition</option>
		   				<option value="New">New</option>
		   				<option value="Manufacturer Refurbished">Manufacturer Refurbished</option>
						<option value="Used/Like New">Used/Like New</option>
						<option value="Used/Acceptable">Used/Acceptable</option>
						<option value="For Parts/Not Working">For Parts/Not Working</option>
					</select>		
			
					
		      	<h3>What color are you looking for?</h3>
	   				<select name="item_color" onChange="check3(this);" required>
	   					<option value="Any">Any Color</option>
		   				<option value="White">White</option>
						<option value="Black">Black</option>
						<option value="Silver">Silver</option>
						<option value="Gold">Gold</option>
						<option value="Brown">Brown</option>
						<option value="Wood">Wood</option>
						<option value="Clear">Clear</option>				
						<option value="Red">Red</option>
						<option value="Orange">Orange</option>
						<option value="Yellow">Yellow</option>
						<option value="Green">Green</option>
						<option value="Blue">Blue</option>
						<option value="Purple">Purple</option>
						<option value="Pink">Pink</option>
						<option value="Multi-Color">Multi-Color</option>
						<option value="Other">Other</option>		
					</select>		
					<div id="other-div3" style="display:none;">
						<br>
				        <label>Enter the color you are looking for:  
				        <input id="other-input3"></input></label>
					</div>					
				
		      	<h3>What type of material are you looking for?</h3>
	   				<select name="item_material" onChange="check4(this);" required>
	   					<option value="Any">Any Material</option>
	   					<option value="Ash">Ash</option>
	   					<option value="Birch">Birch</option>  
						<option value="Brass">Brass</option>   				
		   				<option value="Bronze">Bronze</option>
						<option value="Ceramic">Ceramic</option>
						<option value="Cherry">Cherry</option>	  
						<option value="Copper">Copper</option> 				
						<option value="Crystal">Crystal</option>	   				
						<option value="Glass">Glass</option>
						<option value="Iron">Iron</option>
						<option value="Mahogany">Mahogany</option>	
						<option value="Maple">Maple</option>	
						<option value="Marble">Marble</option>
						<option value="Pine">Pine</option>			
						<option value="Plastic">Plastic</option>
						<option value="Recycled Material">Recycled Material</option>	
						<option value="Steel">Steel</option>	
						<option value="Stone">Stone</option>
						<option value="Teak">Teak</option>
						<option value="Walnut">Walnut</option> 
						<option value="Wicker">Wicker</option>						
						<option value="Other">Other</option>
					</select>
					<div id="other-div4" style="display:none;">
						<br>
				        <label>Enter the material you are looking for:  
				        <input id="other-input4"></input></label>
					</div>	
					
		      	<h3>What type of fabric are you looking for?</h3>
	   				<select name="chair_fabric" onChange="check5(this);" required>
	   					<option value="Any">Any Fabric</option>
	   					<option value="Canvas">Canvas</option>
	   					<option value="Cotton">Cotton</option>
	   					<option value="Faux Leather">Faux Leather</option>
	   					<option value="Leather">Leather</option>
	   					<option value="Microfiber">Microfiber</option>
	   					<option value="Polyester">Polyester</option>
	   					<option value="Silk">Silk</option>
	   					<option value="Suede">Suede</option>
	   					<option value="Velvet">Velvet</option>
	   					<option value="Vinyl">Vinyl</option>
	   					<option value="Wool">Wool</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div5" style="display:none;">
						<br>
				        <label>Enter the fabric you are looking for:  
				        <input id="other-input5"></input></label>
					</div>	
				
		      	<h3>How many chair legs are you looking for?</h3>
	   				<select name="chair_num_legs" required>
	   					<option value="Any">Any Number of Legs</option>
		   				<option value="1">1 Leg</option>
						<option value="2">2 Legs</option>
						<option value="3">3 Legs</option>
						<option value="4">4 Legs</option>
						<option value="5 or more">5+ Legs</option>
					</select>
					<br><br>
				      <input type="submit" value="Add to Wishlist">
			</form>

		</div>
		<div class='form'>
		  	<form>
			 	<button formaction="../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>			
		
<!-----------------------------------------------------------------------------------------------
			        ELSE IF THE USER IS LOOKING FOR TABLES
------------------------------------------------------------------------------------------------>	
		<%
		} else if (newItemCategory.equals("table")) { 
		%>
		<div class="form">
		    <form class="tableSearch" method="post" action="check/checkTableWishlist.jsp">
		    	<h1> Table Wishlist </h1>
		    	<br>
		    	<hr>		
		      	<h3>What type of table are you looking for?</h3>
	   				<select name="item_type" onChange="check(this);" required>
	   					<option value="Any">Any Table</option>   
	   					<option value="Accent Table">Accent Table</option>
		   				<option value="Coffee Table">Coffee Table</option>
		   				<option value="Corner Table">Corner Table</option>
		   				<option value="Dining Table">Dining Table</option>	   		
		   				<option value="End Table">End Table</option>
		   				<option value="Folding Table">Folding Table</option>
		   				<option value="Kitchen Table">Kitchen Table</option>
		   				<option value="Outdoors Table">Outdoors Table</option>
		   				<option value="Side Table">Side Table</option>
		   				<option value="TV Table">TV Table</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div" style="display:none;">
						<br>
				        <label>Enter the type of table you are looking for:  
				        <input id="other-input"></input></label>
			   		</div>
				
		      	<h3>What manufacturer are you looking for?</h3>
	   				<select name="item_manufacturer" onChange="check2(this);" required>
	   					<option value="Any">Any Manufacturer</option>  
		   				<option value="Allen + Roth">Allen + Roth</option>
		   				<option value="Ashley Furniture">Ashley Furniture</option>
		   				<option value="Best Choice Products">Best Choice Products</option>
		   				<option value="Carolina Cottage">Carolina Cottage</option>
		   				<option value="Ethan Allen">Ethan Allen</option>
		   				<option value="Guidecraft">Guidecraft</option>
		   				<option value="Homelegance">Homelegance</option>
		   				<option value="IKEA">IKEA</option>
		   				<option value="King">King</option>
		   				<option value="Lexington">Lexington</option>
		   				<option value="Magnussen">Magnussen</option>
		   				<option value="NOVA">NOVA</option>
		   				<option value="Peters-Revington">Peters-Revington</option>
		   				<option value="Potterybarn">Potterybarn</option>
		   				<option value="Suncast">Suncast</option>
		   				<option value="Tennsco">Tennsco</option>
		   				<option value="Umbra">Umbra</option>
		   				<option value="VIFAH">VIFAH</option>
						<option value="Whitehall">Whitehall</option>
						<option value="Wholesale Interiors">Wholesale Interiors</option>
						<option value="Zojirushi">Zojirushi</option>
						<option value="Homemade">Homemade</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div2" style="display:none;">
						<br>
				        <label>Enter the manufacturer you are looking for:  
				        <input id="other-input2"></input></label>
			   		</div>	
					
					<h3>What condition are you looking for?</h3>
	   				<select name="item_condition" required>
	   					<option value="Any">Any Condition</option>
		   				<option value="New">New</option>
		   				<option value="Manufacturer Refurbished">Manufacturer Refurbished</option>
						<option value="Used/Like New">Used/Like New</option>
						<option value="Used/Acceptable">Used/Acceptable</option>
						<option value="For Parts/Not Working">For Parts/Not Working</option>
					</select>		
			
					
		      	<h3>What color are you looking for?</h3>
	   				<select name="item_color" onChange="check3(this);" required>
	   					<option value="Any">Any Color</option>
		   				<option value="White">White</option>
						<option value="Black">Black</option>
						<option value="Silver">Silver</option>
						<option value="Gold">Gold</option>
						<option value="Brown">Brown</option>
						<option value="Wood">Wood</option>
						<option value="Clear">Clear</option>				
						<option value="Red">Red</option>
						<option value="Orange">Orange</option>
						<option value="Yellow">Yellow</option>
						<option value="Green">Green</option>
						<option value="Blue">Blue</option>
						<option value="Purple">Purple</option>
						<option value="Pink">Pink</option>
						<option value="Multi-Color">Multi-Color</option>
						<option value="Other">Other</option>		
					</select>
					<div id="other-div3" style="display:none;">
						<br>
				        <label>Enter the color you are looking for:  
				        <input id="other-input3"></input></label>
			   		</div>						
				
		      	<h3>What type of material are you looking for?</h3>
	   				<select name="item_material" onChange="check4(this);" required>
	   					<option value="Any">Any Material</option>
	   					<option value="Ash">Ash</option>
	   					<option value="Birch">Birch</option>  
						<option value="Brass">Brass</option>   				
		   				<option value="Bronze">Bronze</option>
						<option value="Ceramic">Ceramic</option>
						<option value="Cherry">Cherry</option>	  
						<option value="Copper">Copper</option> 				
						<option value="Crystal">Crystal</option>	   				
						<option value="Glass">Glass</option>
						<option value="Iron">Iron</option>
						<option value="Mahogany">Mahogany</option>	
						<option value="Maple">Maple</option>	
						<option value="Marble">Marble</option>
						<option value="Pine">Pine</option>			
						<option value="Plastic">Plastic</option>
						<option value="Recycled Material">Recycled Material</option>	
						<option value="Steel">Steel</option>	
						<option value="Stone">Stone</option>
						<option value="Teak">Teak</option>
						<option value="Walnut">Walnut</option> 
						<option value="Wicker">Wicker</option>						
						<option value="Other">Other</option>
					</select>
					<div id="other-div4" style="display:none;">
						<br>
				        <label>Enter the type of material you are looking for:  
				        <input id="other-input4"></input></label>
			   		</div>
					
		      	<h3>What type of shape are you looking for?</h3>
	   				<select name="table_shape" onChange="check5(this);" required>
	   					<option value="Any">Any Shape</option>
	   					<option value="Hexagon">Hexagon</option>
	   					<option value="Octagon">Octagon</option>
	   					<option value="Oval">Oval</option>
	   					<option value="Rectangle">Rectangle</option>
	   					<option value="Round">Round</option>
	   					<option value="Square">Square</option>
	   					<option value="Triangle">Triangle</option>
	   					<option value="S-Shaped">S-Shaped</option>
	   					<option value="Other">Other</option>
					</select>
					<div id="other-div5" style="display:none;">
						<br>
				        <label>Enter the type of shape you are looking for:  
				        <input id="other-input5"></input></label>
			   		</div>
				
		      	<h3>How many table legs are you looking for?</h3>
	   				<select name="table_num_legs" required>
	   					<option value="Any">Any Number of Legs</option>
		   				<option value="1">1 Leg</option>
						<option value="2">2 Legs</option>
						<option value="3">3 Legs</option>
						<option value="4">4 Legs</option>
						<option value="5 or more">5+ Legs</option>
					</select>
					<br><br>		
				<input type="submit" value="Add to Wishlist">     
		      
			</form>	     
		</div>
		<div class='form'>
		  	<form>
			 	<button formaction="../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>		

<!-----------------------------------------------------------------------------------------------
			        ELSE IF THE USER IS LOOKING FOR LAMPS
------------------------------------------------------------------------------------------------>			
		<%
		} else if (newItemCategory.equals("lamp")) {
		%>
  		<div class="form">
		  	  <form class="lampSearch" method="post" action="check/checkLampWishlist.jsp">
		    	<h1> Lamp Wishlist </h1>
		    	<br>
		    	<hr>		
				<h3>What type of lamp are you looking for?</h3>
	   				<select name="item_type" onChange="check(this);" required>
	   					<option value="Any">Any Lamp</option>
		   				<option value="bedside lamp">Bedside Lamp</option>
						<option value="desktop lamp">Desktop Lamp</option>
						<option value="floor lamp">Floor Lamp</option>
						<option value="hanging lamp">Hanging Lamp</option>
						<option value="lava lamp">Lava Lamp</option>		
						<option value="Oil lamp">Oil Lamp</option>			
						<option value="Table lamp">Table Lamp</option>
						<option value="Alternate Style Lamp">Alternate-Style Lamp</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div" style="display:none;">
						<br>
				        <label>Enter the type of lamp you are looking for:  
				        <input id="other-input"></input></label>
					</div>
				
		      	<h3>What manufacturer are you looking for?</h3>
	   				<select name="item_manufacturer" onChange="check2(this);" required>
	   					<option value="Any">Any Manufacturer</option>   
						<option value="360 Lighting">360 Lighting</option>
						<option value="Allen + Roth">Allen + Roth</option>
						<option value="Barnes and Ivy">Barnes and Ivy</option>
						<option value="ECR4Kids">ECR4Kids</option>
						<option value="Fine Art Lamps">Fine Art Lamps</option>
						<option value="IKEA">IKEA</option>
						<option value="Lighting Ever">Lighting Ever</option>
						<option value="Nordic Ware">Nordic Ware</option>
						<option value="Sterling Industries">Sterling Industries</option>
						<option value="Target">Target</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div2" style="display:none;">
						<br>
				        <label>Enter the manufacturer you are looking for:  
				        <input id="other-input2"></input></label>
					</div>	
					
					<h3>What condition are you looking for?</h3>
	   				<select name="item_condition" required>
	   					<option value="Any">Any Condition</option>
		   				<option value="New">New</option>
		   				<option value="Manufacturer Refurbished">Manufacturer Refurbished</option>
						<option value="Used/Like New">Used/Like New</option>
						<option value="Used/Acceptable">Used/Acceptable</option>
						<option value="For Parts/Not Working">For Parts/Not Working</option>
					</select>		
					
		      	<h3>What color are you looking for?</h3>
	   				<select name="item_color" onChange="check3(this);" required>
	   					<option value="Any">Any Color</option>
		   				<option value="White">White</option>
						<option value="Black">Black</option>
						<option value="Silver">Silver</option>
						<option value="Gold">Gold</option>
						<option value="Brown">Brown</option>
						<option value="Wood">Wood</option>
						<option value="Clear">Clear</option>				
						<option value="Red">Red</option>
						<option value="Orange">Orange</option>
						<option value="Yellow">Yellow</option>
						<option value="Green">Green</option>
						<option value="Blue">Blue</option>
						<option value="Purple">Purple</option>
						<option value="Pink">Pink</option>
						<option value="Multi-Color">Multi-Color</option>
						<option value="Other">Other</option>		
					</select>
					<div id="other-div3" style="display:none;">
						<br>
				        <label>Enter the color you are looking for:  
				        <input id="other-input3"></input></label>
					</div>						
				
		      	<h3>What type of material are you looking for?</h3>
	   				<select name="item_material" onChange="check4(this);" required>
	   					<option value="Any">Any Material</option>
	   					<option value="Ash">Ash</option>
	   					<option value="Birch">Birch</option>  
						<option value="Brass">Brass</option>   				
		   				<option value="Bronze">Bronze</option>
						<option value="Ceramic">Ceramic</option>
						<option value="Cherry">Cherry</option>	  
						<option value="Copper">Copper</option> 				
						<option value="Crystal">Crystal</option>	   				
						<option value="Glass">Glass</option>
						<option value="Iron">Iron</option>
						<option value="Mahogany">Mahogany</option>	
						<option value="Maple">Maple</option>	
						<option value="Marble">Marble</option>
						<option value="Pine">Pine</option>			
						<option value="Plastic">Plastic</option>
						<option value="Recycled Material">Recycled Material</option>	
						<option value="Steel">Steel</option>	
						<option value="Stone">Stone</option>
						<option value="Teak">Teak</option>
						<option value="Walnut">Walnut</option> 
						<option value="Wicker">Wicker</option>						
						<option value="Other">Other</option>
					</select>
					<div id="other-div4" style="display:none;">
						<br>
				        <label>Enter the type of material you are looking for:  
				        <input id="other-input4"></input></label>
					</div>
			
		      	<h3>What type of light source does this lamp use?</h3>
	   				<select name="lamp_light_type" onChange="check5(this);" required>
	   					<option value="Any">Any Type of Light</option>
	   					<option value="Fiber Optic">Fiber Optic</option>
		   				<option value="Fluorescent">Fluorescent</option>
						<option value="Halogen">Halogen</option>
						<option value="Laser">Laser</option>
						<option value="LED">LED</option>
						<option value="Neon">Neon</option>
						<option value="Oil-Based Flame">Oil-Based Flame</option>
						<option value="Phosphorescent">Phosphorescent</option>
						<option value="Other">Other</option>
					</select>
					<div id="other-div5" style="display:none;">
						<br>
				        <label>Enter the type of light source you are looking for:  
				        <input id="other-input5"></input></label>
					</div>
				
		      	<h3>How many light bulbs does the lamp support?</h3>
	   				<select name="lamp_num_bulbs" required>
	   					<option value="Any">Any Number of Light Bulbs</option>
		   				<option value="1">1 Light Bulb</option>
						<option value="2">2 Light Bulbs</option>
						<option value="3">3 Light Bulbs</option>
						<option value="4 or more">4+ Light Bulbs</option>
					</select>
				<br><br>	
				<input type="submit" value="Add to Wishlist">
		    </form>
		</div>
		<div class='form'>
		  	<form>
			 	<button formaction="../home/home.jsp">Return Home</button>
		  	</form>	  	
		</div>	

		<%
		} 
		
	} catch (Exception ex) {
		%> 
		<script> 
		    alert("SERVER ERROR: An unexpected error has occurred. Please try again.");
		    window.location.href = "wishlistHome.jsp";
		</script>
		<%
	}
	%>
	
	
		<!-----------------------------------------------------------------------------------------------
			        FUNCTIONS TO ALLOW USER TO INPUT THEIR OWN INFORMATION IF "OTHER" IS A CHOICE
		------------------------------------------------------------------------------------------------>	
		<script>
	    function check(option) {
	        if (option.value == "Other") {
	            document.getElementById("other-div").style.display = 'block';
	        } else {
	            document.getElementById("other-div").style.display = 'none';
	        }
	    }
	    
	    function check2(option) {
	        if (option.value == "Other") {
	            document.getElementById("other-div2").style.display = 'block';
	        } else {
	            document.getElementById("other-div2").style.display = 'none';
	        }
	    }
	    
	    function check3(option) {
	        if (option.value == "Other") {
	            document.getElementById("other-div3").style.display = 'block';
	        } else {
	            document.getElementById("other-div3").style.display = 'none';
	        }
	    }
	    
	    function check4(option) {
	        if (option.value == "Other") {
	            document.getElementById("other-div4").style.display = 'block';
	        } else {
	            document.getElementById("other-div4").style.display = 'none';
	        }
	    }
	    
	    function check5(option) {
	        if (option.value == "Other") {
	            document.getElementById("other-div5").style.display = 'block';
	        } else {
	            document.getElementById("other-div5").style.display = 'none';
	        }
	    }
		</script>	
	
	
</body>
</html>