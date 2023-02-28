# SpendingTracking
A Sample app which enables the creation of Bank Cards, adds multiple transactions per Card and allows filtering transactions based on a transaction category. The app supports iPhone but also iPad with using size classes. 

# iPhone - Main
At the start, the main screen shows empty because there are no Credit cards saved.

<img src="images/iphone1.png" widht= 150 height = 300  hspace="0">

# iPhone - Main - Add Card
When adding a Credit Card, the ser prefills information regarding that Card. It is possible to pick between 3 types: Visa, Mastercard and Discover, add the expiration date and also choose the card's colour. When all is set it is possible to save the card. 

<img src="images/iphone2.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone3.png" widht= 150 height = 300  hspace="0"> 
<img src="images/iphone4.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone5.png" widht= 150 height = 300  hspace="0">
<img src="images/iphone6.png" widht= 150 height = 300  hspace="0"> 


# iPhone - Main - Added Card
When created Cards, they are shown on the main top container. Now when there is a Card, there can also be added a transaction per specific Card. Also the user is able to edit or delete the specific card by selecting the three dots on the upper right corner of the card.

<img src="images/iphone7.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone8.png" widht= 150 height = 300  hspace="0">
<img src="images/iphone17.png" widht= 150 height = 300  hspace="0">

# iPhone - Main - Add Transaction
Every Card can have transactions. While adding transactions it is possible to pick one or many categories for that specific transaction. The categories have a prefilled state but it is also possible to add new or delete a category. When the transaction is added to the main screen, the user can also perform a delete operation on a specific transaction

<img src="images/iphone9.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone11.png" widht= 150 height = 300  hspace="0"> 
<img src="images/iphone12.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone10.png" widht= 150 height = 300  hspace="0">
<img src="images/iphone13.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone18.png" widht= 150 height = 300  hspace="0">

# iPhone - Main - Filtering Transactions
Users can filter transactions based on a specific category or multiple categories. If no category is selected the user should not see any transactions.

<img src="images/iphone14.png" widht= 150 height = 300  hspace="0"> <img src="images/iphone15.png" widht= 150 height = 300  hspace="0"> 
<img src="images/iphone16.png" widht= 150 height = 300  hspace="0"> 

# iPad - Main - Add Card
The app also supports portrait/landscape mode for iPad. The Main screen shows a specific UI for iPad. The user has the same functionalities as on the iPhone therefore at the start he needs to add a Card.

<img src="images/ipad1.png" widht= 150 height = 300  hspace="0"> <img src="images/ipad2.png" widht= 150 height = 300  hspace="0"> 
<img src="images/ipad3.png" widht= 150 height = 300  hspace="0"> <img src="images/ipad4.png" widht= 150 height = 300  hspace="0"> 

# iPad - Main - Add Transaction
As on the iPhone, it is possible to add a transaction per Card.

<img src="images/ipad5.png" widht= 150 height = 300  hspace="0"> <img src="images/ipad6.png" widht= 150 height = 300  hspace="0"> 

# iPad - Main - Landscape mode 
<img src="images/ipad7.png" widht= 150 height = 300  hspace="0">

# iPad - Main - Landscape mode - Detecting size class
in Landscape, the UI can show as compact or regular when the user uses a split screen with another app. If the UI is set as .compact size class it switches UI to be rendered as iPhone, otherwise, it shows iPad UI.

<img src="images/ipad8.png" widht= 150 height = 300  hspace="0"> <img src="images/ipad9.png" widht= 150 height = 300  hspace="0"> 


# Main Features:
- SwiftUI for building UI
- Core Data, 
  - CRUD
  - Relations: 
    - one to many, transactions per card
    - many to many, categories on transactions 
- Usage pf size class for iPad UI
