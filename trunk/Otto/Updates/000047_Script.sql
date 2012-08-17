delete from payments;

delete from messages m where m.message_dtm is null;
