import { LightningElement } from 'lwc';

export default class SelectOptionsInUlLi extends LightningElement {
      selectedOption;
      showOptions = false;
    
      handleOptionClick(event) {
        this.selectedOption = event.target.innerText;
        console.log(event.currentTarget.innerText);
      }
    
      toggleOptions() {
        this.showOptions = !this.showOptions;
      }
    }
    



    // $("ul").on("click", ".init", function() {
    //     $(this).closest("ul").children('li:not(.init)').toggle();
    // });
    
    // var allOptions = $("ul").children('li:not(.init)');
    // $("ul").on("click", "li:not(.init)", function() {
    //     allOptions.removeClass('selected');
    //     $(this).addClass('selected');
    //     $("ul").children('.init').html($(this).html());
    //     allOptions.toggle();
    // });


    //working code for option select 
//     <!DOCTYPE html>
// <html>
//   <head>
//     <style>
    //   #cars {
    //     display: none;
    //   }
    //   * {
    //     padding: 0;
    //     margin: 0;
    //   }
    //   .wrapper {
    //     max-width: 400px;
    //     position: relative;
    //     margin: 0 auto;
    //     left: 0;
    //     right: 0;
    //   }

    //   ul {
    //     padding: 0;
    //     margin: 0;
    //   }

    //   li {
    //     list-style: none;
    //   }

    //   .select-field-wrapper {
    //     position: relative;
    //   }
    //   .selected-option-field {
    //     height: 36px;
    //     width: 300px;
    //     background-color: white;
    //     border: 2px solid #4e3c3c;
    //     position: relative;
    //     color: black;
    //     text-align: center;
    //     margin: 0;
    //   }

    //   /* .selected-option-field::after {
    //     content: "\f078";
    //     font-family: FontAwesome;
    //     display: inline-block;
    //     position: absolute;
    //     background: white;
    //     right: 0;
    //   } */
    //   .inner-wrapper {
    //     position: relative;
    //     width: 300px;
    //   }
    //   .arrow {
    //     display: inline-block;
    //     height: 15px;
    //     width: 15px;
    //     position: absolute;
    //     top: 6px;
    //     right: 8px;
    //     background-image: url(https://cdn2.vectorstock.com/i/1000x1000/14/01/down-arrow-icon-vector-21641401.jpg);
    //     background-position: center;
    //     object-fit: scale-down;
    //     background-size: cover;
    //   }
    //   .available-options {
    //     width: 300px;
    //     height: 104px;
    //     overflow: hidden;
    //     overflow-y: auto;
    //     border: 1px solid black;
    //   }
    //   .options {
    //     text-align: center;
    //     background: white;
    //   }
    //   .options:hover {
    //     background: grey;
    //   }

    //   .hide-show {
    //     display: none;
    //   }
//     </style>
//     <link
//       rel="stylesheet"
//       href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
//     />
//   </head>
//   <body>
//     <h1>The select element</h1>

//     <p>The select element is used to create a drop-down list.</p>
//     <div class="wrapper">
//       <form action="/action_page.php">
//         <label for="cars">Choose a car:</label>
//         <select name="cars" id="cars">
//           <option value="volvo">Volvo</option>
//           <option value="saab">Saab</option>
//           <option value="opel">Opel</option>
//           <option value="audi">Audi</option>
//         </select>

        // <div class="select-field-wrapper">
        //   <div class="inner-wrapper">
        //     <div class="selected-option-field">Select Options</div>
        //     <div class="arrow"></div>
        //   </div>
        //   <ul class="available-options">
        //     <li class="options">one</li>
        //     <li class="options">two</li>
        //     <li class="options">Three</li>
        //     <li class="options">Four</li>
        //     <li class="options">Five</li>
        //     <li class="options">Six</li>
        //     <li class="options">Seven</li>
        //   </ul>
        // </div>

//         <br /><br />
//         <input type="submit" value="Submit" />
//       </form>
//     </div>
//     <script>
    //   const allLiElement = document.querySelectorAll(".options");
    //   for (var i = 0; i < allLiElement.length; i++) {
    //     allLiElement[i].addEventListener("click", function (event) {
    //       document.querySelector(".selected-option-field").innerText =
    //         event.target.innerText;

    //       console.log(event.currentTarget.innerText);
    //     });
    //   }
    //   document.querySelector(".arrow").addEventListener('click',function(){
    //   document.querySelector(".available-options").classList.toggle('hide-show');
    //   })
//     </script>
//   </body>
// </html>

