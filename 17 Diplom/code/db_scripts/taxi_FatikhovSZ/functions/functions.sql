 /*
14. Создать представление, которое отобразит средний чек за поездку в разных странах.   ------------------------------   14.
Для данного представления в apex необходимо будет создать пончиковую диаграмму.                                         + APEX
*/
create or replace function currency_convert(currency1 int, currency2 int, currency_date date) return number
is
    currency_rate number;
    selected_time timestamp;
begin
    currency_rate:=null;
    
    select max(time_create) into selected_time from rate
        where currency1_id=currency1 and currency2_id=currency2 and time_create<=currency_date;
    
    select rate into currency_rate from rate
        where currency1_id=currency1 and currency2_id=currency2 and time_create=selected_time;
    
    return currency_rate;
end;

------------ modified by FatikhovSZ ------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DecodeBASE64(InBase64Char IN CLOB) RETURN BLOB IS

    blob_loc BLOB;
    clob_trim CLOB;
    res CLOB;
    res2 BLOB;

    lang_context INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    read_offset INTEGER := 1;
    warning INTEGER;
    ClobLen INTEGER := DBMS_LOB.GETLENGTH(InBase64Char);

    amount INTEGER := 1440; -- must be a whole multiple of 4
    buffer RAW(1440);
    stringBuffer VARCHAR2(1440);
    -- BASE64 characters are always simple ASCII. Thus you get never any Mulit-Byte character and having the same size as 'amount' is sufficient

BEGIN

    IF InBase64Char IS NULL OR NVL(ClobLen, 0) = 0 THEN 
        RETURN NULL;
    ELSIF ClobLen<= 32000 THEN
        RETURN (UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(InBase64Char)));
    END IF;        
    -- UTL_ENCODE.BASE64_DECODE is limited to 32k, process in chunks if bigger    

    -- Remove all NEW_LINE from base64 string
    ClobLen := DBMS_LOB.GETLENGTH(InBase64Char);
    DBMS_LOB.CREATETEMPORARY(clob_trim, TRUE);
    LOOP
        EXIT WHEN read_offset > ClobLen;
        --stringBuffer := REPLACE(REPLACE(DBMS_LOB.SUBSTR(InBase64Char, amount, read_offset), CHR(13), NULL), CHR(10), NULL);
        stringBuffer:=DBMS_LOB.SUBSTR(InBase64Char, amount, read_offset);
        DBMS_LOB.WRITEAPPEND(clob_trim, LENGTH(stringBuffer), stringBuffer);
        read_offset := read_offset + amount;
    END LOOP;

    read_offset := 1;
    ClobLen := DBMS_LOB.GETLENGTH(clob_trim);
    DBMS_LOB.CREATETEMPORARY(blob_loc, TRUE);
    LOOP
        EXIT WHEN read_offset > ClobLen;
        buffer := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(DBMS_LOB.SUBSTR(clob_trim, amount, read_offset)));
        DBMS_LOB.WRITEAPPEND(blob_loc, DBMS_LOB.GETLENGTH(buffer), buffer);
        read_offset := read_offset + amount;
    END LOOP;
    
    res2:=blob_loc;

    DBMS_LOB.CREATETEMPORARY(res, TRUE);
    DBMS_LOB.CONVERTTOCLOB(res, blob_loc, DBMS_LOB.LOBMAXSIZE, dest_offset, src_offset,  DBMS_LOB.DEFAULT_CSID, lang_context, warning);

    DBMS_LOB.FREETEMPORARY(blob_loc);
    DBMS_LOB.FREETEMPORARY(clob_trim);
    RETURN res2;    

END DecodeBASE64;


------------ original --------------------------------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION EncodeBASE64(InClearChar IN OUT NOCOPY CLOB) RETURN CLOB IS

    dest_lob BLOB;  
    lang_context INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    read_offset INTEGER := 1;
    warning INTEGER;
    ClobLen INTEGER := DBMS_LOB.GETLENGTH(InClearChar);

    amount INTEGER := 1440; -- must be a whole multiple of 3
    -- size of a whole multiple of 48 is beneficial to get NEW_LINE after each 64 characters 
    buffer RAW(1440);
    res CLOB := EMPTY_CLOB();

BEGIN

    IF InClearChar IS NULL OR NVL(ClobLen, 0) = 0 THEN 
        RETURN NULL;
    ELSIF ClobLen <= 24000 THEN
        RETURN UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(InClearChar)));
    END IF;
    -- UTL_ENCODE.BASE64_ENCODE is limited to 32k/(3/4), process in chunks if bigger    

    DBMS_LOB.CREATETEMPORARY(dest_lob, TRUE);
    DBMS_LOB.CONVERTTOBLOB(dest_lob, InClearChar, DBMS_LOB.LOBMAXSIZE, dest_offset, src_offset, DBMS_LOB.DEFAULT_CSID, lang_context, warning);
    LOOP
        EXIT WHEN read_offset >= dest_offset;
        DBMS_LOB.READ(dest_lob, amount, read_offset, buffer);
        res := res || UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(buffer));       
        read_offset := read_offset + amount;
    END LOOP;
    DBMS_LOB.FREETEMPORARY(dest_lob);
    RETURN res;

END EncodeBASE64;
*/
------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION simple_convert(InClearChar IN CLOB) RETURN BLOB IS

    dest_lob BLOB;  
    lang_context INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    read_offset INTEGER := 1;
    warning INTEGER;
    ClobLen INTEGER := DBMS_LOB.GETLENGTH(InClearChar);

    amount INTEGER := 1440; -- must be a whole multiple of 3
    -- size of a whole multiple of 48 is beneficial to get NEW_LINE after each 64 characters 
    buffer RAW(1440);
    res CLOB := EMPTY_CLOB();
    res2 BLOB;  

BEGIN

    DBMS_LOB.CREATETEMPORARY(dest_lob, TRUE);
    DBMS_LOB.CONVERTTOBLOB(dest_lob, InClearChar, DBMS_LOB.LOBMAXSIZE, dest_offset, src_offset, DBMS_LOB.DEFAULT_CSID, lang_context, warning);
    /*
    LOOP
        EXIT WHEN read_offset >= dest_offset;
        DBMS_LOB.READ(dest_lob, amount, read_offset, buffer);
        res := res || UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(buffer));       
        read_offset := read_offset + amount;
    END LOOP;
    */
    res2:=dest_lob;
    DBMS_LOB.FREETEMPORARY(dest_lob);
    RETURN res2;

END simple_convert;        

------------ modified by FatikhovSZ ------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION EncodeBASE64(InClearChar IN CLOB) RETURN BLOB IS

    dest_lob BLOB;  
    lang_context INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    read_offset INTEGER := 1;
    warning INTEGER;
    ClobLen INTEGER := DBMS_LOB.GETLENGTH(InClearChar);

    amount INTEGER := 1440; -- must be a whole multiple of 3
    -- size of a whole multiple of 48 is beneficial to get NEW_LINE after each 64 characters 
    buffer RAW(1440);
    res CLOB := EMPTY_CLOB();
    buff2 BLOB := EMPTY_BLOB();

BEGIN

    IF InClearChar IS NULL OR NVL(ClobLen, 0) = 0 THEN 
        RETURN NULL;
    ELSIF ClobLen <= 24000 THEN
        RETURN (UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(InClearChar)));
    END IF;
    -- UTL_ENCODE.BASE64_ENCODE is limited to 32k/(3/4), process in chunks if bigger    

    DBMS_LOB.CREATETEMPORARY(dest_lob, TRUE);
    DBMS_LOB.CONVERTTOBLOB(dest_lob, InClearChar, DBMS_LOB.LOBMAXSIZE, dest_offset, src_offset, DBMS_LOB.DEFAULT_CSID, lang_context, warning);
    LOOP
        EXIT WHEN read_offset >= dest_offset;
        DBMS_LOB.READ(dest_lob, amount, read_offset, buffer);
        res := res || UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(buffer));       
        read_offset := read_offset + amount;
    END LOOP;
    DBMS_LOB.FREETEMPORARY(dest_lob);
    
    buff2:=UTL_RAW.CAST_TO_RAW(res);
    RETURN buff2;


END EncodeBASE64;

create function clobfromblob(p_blob blob) return clob is
      l_clob         clob;
      l_dest_offsset integer := 1;
      l_src_offsset  integer := 1;
      l_lang_context integer := dbms_lob.default_lang_ctx;
      l_warning      integer;
   begin
      if p_blob is null then
         return null;
      end if;
      dbms_lob.createTemporary(lob_loc => l_clob
                              ,cache   => false);
      dbms_lob.converttoclob(dest_lob     => l_clob
                            ,src_blob     => p_blob
                            ,amount       => dbms_lob.lobmaxsize
                            ,dest_offset  => l_dest_offsset
                            ,src_offset   => l_src_offsset
                            ,blob_csid    => dbms_lob.default_csid
                            ,lang_context => l_lang_context
                            ,warning      => l_warning);
      return l_clob;
   end;
        
