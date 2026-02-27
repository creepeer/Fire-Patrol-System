package com.ruoyi.system.service.impl;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.time.LocalDate;
import java.util.*;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.ruoyi.common.utils.AliyunOSSOperator;
import com.ruoyi.system.DTO.Device.AddDeviceDTO;
import com.ruoyi.web.controller.common.CommonController;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CDeviceMapper;
import com.ruoyi.system.domain.CDevice;
import com.ruoyi.system.service.ICDeviceService;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;

/**
 * 设施设备Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
@Service
@Slf4j
public class CDeviceServiceImpl implements ICDeviceService 
{
    @Autowired
    private CDeviceMapper cDeviceMapper;
    @Autowired
    private AliyunOSSOperator aliyunOSSOperator;

    /**
     * 查询设施设备
     * 
     * @param id 设施设备主键
     * @return 设施设备
     */
    @Override
    public CDevice selectCDeviceById(Long id)
    {
        return cDeviceMapper.selectCDeviceById(id);
    }


    /**
     * 根据区域ID查询设备列表(包含子树所有设备)
     */
    @Override
    public List<CDevice> selectCDeviceByZoneId(Long zoneId) {
        return cDeviceMapper.selectCDeviceByZoneId(zoneId);
    }

    /**
     * 根据区域ID查询检测设备列表（只有叶子节点记录）
     */
    @Override
    public List<CDevice> selectCDevicePlanByZoneId(Long zoneId) {
        return cDeviceMapper.selectCDevicePlanByZoneId(zoneId);
    }
    /**
     * 查询设施设备列表
     * 
     * @param cDevice 设施设备
     * @return 设施设备
     */
    @Override
    public List<CDevice> selectCDeviceList(CDevice cDevice)
    {
        return cDeviceMapper.selectCDeviceList(cDevice);
    }

    /**
     * 新增设施设备
     * 
     * @param Data 设施设备
     * @return 结果
     */
    @Override
    public int insertCDevice(AddDeviceDTO Data)
    {
        System.out.println(Data);
        CDevice device=new CDevice();
        device.setName(Data.getName());
        device.setCategoryId(Data.getCategoryId());
        device.setProjectId(Data.getProjectId());
        device.setZoneId1(Data.getZoneId1());
        device.setZoneId2(Data.getZoneId2());
        device.setZoneId3(Data.getZoneId3());
        device.setLocation(Data.getLocation());
        device.setRelatedLocation(Data.getRelatedLocation());
        device.setBrand(Data.getBrand());
        device.setModel(Data.getModel());
        device.setIsHost(Data.getIsHost());
        device.setIsBus(Data.getIsBus());
        device.setParentDeviceId(Data.getParentDeviceId());
        device.setStartDate(Data.getStartDate());
        device.setProductionDate(Data.getProductionDate());
        device.setWarrantyStart(Data.getWarrantyStart());
        device.setServiceLife(Data.getServiceLife());
        device.setDeviceStatus(Data.getDeviceStatus());
        device.setBindStatus(Data.getBindStatus());
        device.setQrCode(Data.getQrCode());
        device.setQrUrl(Data.getQrUrl());
        device.setDiagram2d(Data.getDiagram2d());
        device.setLat(Data.getLat());
        device.setLng(Data.getLng());
        device.setRemark(Data.getRemark());

        int result = cDeviceMapper.insertCDevice(device);
        Long deviceId =device.getId();
        String code=createDeviceQRCode(deviceId);
        device.setQrCode("DE"+deviceId);
        device.setQrUrl(code);
        cDeviceMapper.updateCDevice(device);

        // 3. 如果插入成功且是主机设备且有子设备，更新子设备的父设备ID
        if (result > 0 && Data.getIsHost() == 1 &&
                Data.getChildDeviceIds() != null && !Data.getChildDeviceIds().isEmpty()) {
            associateChildDevices(device.getId(), Data.getChildDeviceIds());
        }
       return result;
    }
    private void associateChildDevices(Long hostId, List<Long> childIds) {
        for (Long childId : childIds) {
            CDevice child = cDeviceMapper.selectCDeviceById(childId);
            if (child != null && child.getIsHost() != 1) {
                child.setParentDeviceId(hostId);
                cDeviceMapper.updateCDevice(child);
            }
        }
    }

    /**
     * 修改设施设备
     * 
     * @param cDevice 设施设备
     * @return 结果
     */
    @Override
    public int updateCDevice(CDevice cDevice)
    {
        return cDeviceMapper.updateCDevice(cDevice);
    }

    /**
     * 批量删除设施设备
     * 
     * @param ids 需要删除的设施设备主键
     * @return 结果
     */
    @Override
    public int deleteCDeviceByIds(Long[] ids)
    {
        return cDeviceMapper.deleteCDeviceByIds(ids);
    }

    /**
     * 删除设施设备信息
     * 
     * @param id 设施设备主键
     * @return 结果
     */
    @Override
    public int deleteCDeviceById(Long id)
    {
        return cDeviceMapper.deleteCDeviceById(id);
    }
    /**
     * 设备二维码生成（多个）
     */

    public String createDeviceQRCode(Long id) {
        // 1. 二维码内容
        try {
            // 1. 二维码内容
//            String qrMessage = "http://121.43.195.181:9091/EQM/scan?deviceId="+id.toString();
//            String qrMessage = "http://localhost/EQM/scan?deviceId="+id.toString();
            String qrMessage = "https://www.zjhzqsh.com/plan/user/scan?deviceId="+id.toString();
            // 2. 二维码参数
            int CODE_WIDTH = 300;
            int CODE_HEIGHT = 300;
            int FRONT_COLOR = 0xFF000000;    // 黑色（ARGB格式）
            int BACKGROUND_COLOR = 0xFFFFFFFF; // 白色（ARGB格式）

            // 3. 设置编码参数
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
            hints.put(EncodeHintType.MARGIN, 1); // 二维码边距

            // 4. 生成BitMatrix
            MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
            BitMatrix bitMatrix = multiFormatWriter.encode(
                    qrMessage,
                    BarcodeFormat.QR_CODE,
                    CODE_WIDTH,
                    CODE_HEIGHT,
                    hints
            );

            // 5. 将BitMatrix转换为BufferedImage
            BufferedImage image = new BufferedImage(CODE_WIDTH, CODE_HEIGHT, BufferedImage.TYPE_INT_RGB);
            for (int x = 0; x < CODE_WIDTH; x++) {
                for (int y = 0; y < CODE_HEIGHT; y++) {
                    image.setRGB(x, y, bitMatrix.get(x, y) ? FRONT_COLOR : BACKGROUND_COLOR);
                }
            }

            // 6. 保存图片到文件
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "PNG", baos);
            //7.上传至OSS服务器
            byte[] content = baos.toByteArray();
            String originalFilename=baos.toString();
            String objectName = UUID.randomUUID().toString().replace("-", "") + ".png";
            String fileUrl =aliyunOSSOperator.upload(content,objectName);
            return fileUrl;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }
}
