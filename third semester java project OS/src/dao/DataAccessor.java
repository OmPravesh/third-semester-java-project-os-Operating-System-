package dao;

import java.sql.SQLException;
import java.util.List;

public interface DataAccessor<T> {
    T read(String key) throws SQLException;
    T update(T entity) throws SQLException;
    List<T> findAll() throws SQLException;
}