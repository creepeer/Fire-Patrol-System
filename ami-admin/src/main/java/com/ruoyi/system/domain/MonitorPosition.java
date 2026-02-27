package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 监控位置对象
 * 
 * @author ruoyi
 */
public class MonitorPosition extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** X坐标 */
    private Double x;

    /** Y坐标 */
    private Double y;

    public void setX(Double x) 
    {
        this.x = x;
    }

    public Double getX() 
    {
        return x;
    }

    public void setY(Double y) 
    {
        this.y = y;
    }

    public Double getY() 
    {
        return y;
    }

    @Override
    public String toString() {
        return "MonitorPosition{" +
            "x=" + x +
            ", y=" + y +
            '}';
    }
}
