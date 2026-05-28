CLASS z_irn_exp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS Invoiceno importing invo type string
     exportING export_irn_data type string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_IRN_EXP IMPLEMENTATION.


  METHOD Invoiceno.

      DATA: lt_data TYPE TABLE OF zdb_einv_resp,
          ls_data TYPE zdb_einv_resp.

            SELECT *
      FROM zdb_einv_resp
      WHERE status = 'Generated' and docno = @invo
      into @data(wa_irn).


if wa_irn is not initial.

export_irn_data = wa_irn-ackno.
endif.
  endselect.
endmethod.
ENDCLASS.
