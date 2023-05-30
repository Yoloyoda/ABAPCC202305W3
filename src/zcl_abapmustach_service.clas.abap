CLASS zcl_abapmustach_service DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_shop_item,
        name      TYPE string,
        price(10) TYPE p DECIMALS 2,
      END OF ty_shop_item,

      ty_shop_item_tt TYPE STANDARD TABLE OF ty_shop_item WITH EMPTY KEY,

      BEGIN OF ty_shop,
        shop_name TYPE string,
        items     TYPE ty_shop_item_tt,
      END OF ty_shop.

    CONSTANTS:
        cns_nl   TYPE string VALUE cl_abap_char_utilities=>newline.


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abapmustach_service IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA: lo_mustache TYPE REF TO zcl_mustache,
          lv_text     TYPE string,
          lt_data     TYPE STANDARD TABLE OF ty_shop.
    FIELD-SYMBOLS:<lw_data> TYPE ty_shop.

    "Fill data
    APPEND INITIAL LINE TO lt_data ASSIGNING <lw_data>.
    <lw_data> = VALUE #( shop_name = 'Max burger' ).
    <lw_data>-items = VALUE #( ( name = 'Original burger' price = '10.00' )
                               ( name = 'Spicy Advocado burger' price = '20.00' )
                                ).

    APPEND INITIAL LINE TO lt_data ASSIGNING <lw_data>.
    <lw_data> = VALUE #( shop_name = 'Rekas burger' ).
    <lw_data>-items = VALUE #( ( name = 'Brosan' price = '10.00' )
                               ( name = 'Malmo Smash Star ' price = '20.00' )
                                ).

    TRY.
        lo_mustache = zcl_mustache=>create(
            '<html><style>table, th, td {  border:1px solid black;}</style><body>' && cns_nl &&
            'Welcome to <b>{{shop_name}}</b>!' && cns_nl &&
            '<table style="width:20%">' && cns_nl &&
            ' <tr><th>Name</th><th>Price</td></tr>' && cns_nl &&
            ' {{#items}}'  && cns_nl &&
            ' <tr><td>{{name}}</td><td>${{price}}</td></tr>' && cns_nl &&
            ' {{/items}}' &&
            '</table>' && cns_nl &&
            '</body></html>' ).
      CATCH cx_root.
    ENDTRY.

    lv_text  = lo_mustache->render( lt_data ).

    response->set_text(  lo_mustache->render( lt_data ) ).

  ENDMETHOD.
ENDCLASS.
