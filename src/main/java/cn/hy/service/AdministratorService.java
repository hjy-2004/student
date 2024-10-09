package cn.hy.service;

import cn.hy.entity.Administrator;
import cn.hy.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdministratorService {

    @Autowired
    private AdminRepository adminRepository;

    public Administrator getAdminInfo(int id) {
        return adminRepository.findById(id).orElse(null);
    }

    public Administrator updateAdminInfo(Administrator adminInfo) {
        return adminRepository.save(adminInfo);
    }
}
