class ZCX_BC_LOG definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of OBJECT_UNDEFINED,
      msgid type symsgid value 'ZBC',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'OBJECT',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of OBJECT_UNDEFINED .
  constants:
    begin of SUBOBJECT_UNDEFINED,
      msgid type symsgid value 'ZBC',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'OBJECT',
      attr2 type scx_attrname value 'SUBOBJECT',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SUBOBJECT_UNDEFINED .
  constants:
    begin of CANT_CREATE_INSTANCE,
      msgid type symsgid value 'ZBC',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'OBJECT',
      attr2 type scx_attrname value 'SUBOBJECT',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CANT_CREATE_INSTANCE .
  data OBJECT type BALOBJ_D .
  data SUBOBJECT type BALSUBOBJ .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !OBJECT type BALOBJ_D optional
      !SUBOBJECT type BALSUBOBJ optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_BC_LOG IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->OBJECT = OBJECT .
me->SUBOBJECT = SUBOBJECT .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.